import { NextResponse } from "next/server";
import { timingSafeEqual } from "crypto";
import { createSession } from "@/lib/xác thực";

export async function POST(req: Request) {
 try {
  const {email,password}=await req.json();
  const expectedEmail=process.env.ADMIN_EMAIL||"";
  const expectedPassword=process.env.ADMIN_PASSWORD||"";
  if(!expectedEmail||!expectedPassword||expectedPassword==="change-this-before-deploying") return NextResponse.json({error:"Admin chưa được cấu hình an toàn trong biến môi trường."},{status:503});
  const a=Buffer.from(String(email||""));const b=Buffer.from(expectedEmail);
  const c=Buffer.from(String(password||""));const d=Buffer.from(expectedPassword);
  const emailOk=a.length===b.length&&timingSafeEqual(a,b);
  const passwordOk=c.length===d.length&&timingSafeEqual(c,d);
  if(!emailOk||!passwordOk)return NextResponse.json({error:"Email hoặc mật khẩu không đúng."},{status:401});
  await createSession(expectedEmail);
  return NextResponse.json({ok:true});
 } catch { return NextResponse.json({error:"Yêu cầu không hợp lệ."},{status:400}); }
    }
