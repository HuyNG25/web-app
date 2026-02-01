using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using PCM.API.DTOs;
using PCM.Core.Entities;
using PCM.Core.Enums;
using PCM.Infrastructure.Data;

namespace PCM.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly UserManager<IdentityUser> _userManager;
    private readonly SignInManager<IdentityUser> _signInManager;
    private readonly PcmDbContext _context;
    private readonly IConfiguration _configuration;

    public AuthController(
        UserManager<IdentityUser> userManager,
        SignInManager<IdentityUser> signInManager,
        PcmDbContext context,
        IConfiguration configuration)
    {
        _userManager = userManager;
        _signInManager = signInManager;
        _context = context;
        _configuration = configuration;
    }

    [HttpPost("register")]
    public async Task<ActionResult<ApiResponse<AuthResponseDto>>> Register([FromBody] RegisterDto dto)
    {
        var user = new IdentityUser
        {
            UserName = dto.Email,
            Email = dto.Email
        };

        var result = await _userManager.CreateAsync(user, dto.Password);
        if (!result.Succeeded)
        {
            return BadRequest(new ApiResponse<AuthResponseDto>(false, string.Join(", ", result.Errors.Select(e => e.Description)), null));
        }

        // Create Member profile
        var member = new Member
        {
            FullName = dto.FullName,
            Phone = dto.Phone,
            Email = dto.Email,
            UserId = user.Id,
            JoinDate = DateTime.UtcNow,
            WalletBalance = 0,
            Tier = MemberTier.Standard
        };
        _context.Members.Add(member);
        await _context.SaveChangesAsync();

        // Add to Member role
        await _userManager.AddToRoleAsync(user, "Member");

        var token = GenerateJwtToken(user, member);
        var userDto = MapToUserDto(user, member);

        return Ok(new ApiResponse<AuthResponseDto>(true, "Registration successful", new AuthResponseDto(token, userDto)));
    }

    [HttpPost("login")]
    public async Task<ActionResult<ApiResponse<AuthResponseDto>>> Login([FromBody] LoginDto dto)
    {
        var user = await _userManager.FindByEmailAsync(dto.Email);
        if (user == null)
        {
            return Unauthorized(new ApiResponse<AuthResponseDto>(false, "Invalid email or password", null));
        }

        var result = await _signInManager.CheckPasswordSignInAsync(user, dto.Password, false);
        if (!result.Succeeded)
        {
            return Unauthorized(new ApiResponse<AuthResponseDto>(false, "Invalid email or password", null));
        }

        var member = await _context.Members.FirstOrDefaultAsync(m => m.UserId == user.Id);
        if (member == null)
        {
            return NotFound(new ApiResponse<AuthResponseDto>(false, "Member profile not found", null));
        }

        var token = GenerateJwtToken(user, member);
        var userDto = MapToUserDto(user, member);

        return Ok(new ApiResponse<AuthResponseDto>(true, "Login successful", new AuthResponseDto(token, userDto)));
    }

    [Authorize]
    [HttpGet("me")]
    public async Task<ActionResult<ApiResponse<UserDto>>> GetCurrentUser()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var user = await _userManager.FindByIdAsync(userId!);
        var member = await _context.Members.FirstOrDefaultAsync(m => m.UserId == userId);

        if (user == null || member == null)
        {
            return NotFound(new ApiResponse<UserDto>(false, "User not found", null));
        }

        return Ok(new ApiResponse<UserDto>(true, null, MapToUserDto(user, member)));
    }

    private string GenerateJwtToken(IdentityUser user, Member member)
    {
        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, user.Id),
            new(ClaimTypes.Email, user.Email!),
            new("MemberId", member.Id.ToString()),
            new(ClaimTypes.Name, member.FullName)
        };

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]!));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: _configuration["Jwt:Issuer"],
            audience: _configuration["Jwt:Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddDays(7),
            signingCredentials: creds
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    private static UserDto MapToUserDto(IdentityUser user, Member member)
    {
        return new UserDto(
            user.Id,
            user.Email!,
            member.Id,
            member.FullName,
            member.WalletBalance,
            member.Tier.ToString(),
            member.RankLevel,
            member.AvatarUrl
        );
    }
}
