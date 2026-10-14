import { SignJWT, jwtVerify } from "jose";
import { cookies } from "next/headers";

const key = () => {
  const secret = process.env.JWT_SECRET;
  if (!secret || secret.length < 32) throw new Error("JWT_SECRET must be at least 32 characters");
  return new TextEncoder().encode(secret);
};
export async function createSession(email: string) {
  const token = await new SignJWT({ role: "admin", email }).setProtectedHeader({ alg: "HS256" })
    .setIssuedAt().setExpirationTime("8h").sign(key());
  cookies().set("moehehe_admin", token, { httpOnly: true, secure: process.env.NODE_ENV === "production", sameSite: "lax", path: "/", maxAge: 8 * 60 * 60 });
}
export async function isAdmin() {
  try {
    const token = cookies().get("moehehe_admin")?.value;
    if (!token) return false;
    const { payload } = await jwtVerify(token, key());
    return payload.role === "admin";
  } catch { return false; }
}
export function clearSession() { cookies().delete("moehehe_admin"); }
