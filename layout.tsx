import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "MoeHeHe STORE",
  description: "MoeHeHe STORE - cửa hàng tài khoản game",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return <html lang="vi"><body>{children}</body></html>;
}
