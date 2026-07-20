import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: "Mitali's Portfolio",
  description: 'Photographer portfolio showcasing creative work',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
