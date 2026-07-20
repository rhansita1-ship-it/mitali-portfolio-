# Mitali's Portfolio

A modern, responsive portfolio website built with Next.js 14 and Tailwind CSS.

## Features

- 🎨 Clean, modern design
- 📱 Fully responsive
- ⚡ Fast performance with Next.js
- 🎬 Support for images and videos
- 🚀 Deployed on Vercel

## Getting Started

### Prerequisites

- Node.js 18+ and npm/yarn

### Installation

1. Clone the repository:
```bash
git clone https://github.com/rhansita1-ship-it/mitali-portfolio-.git
cd mitali-portfolio-
```

2. Install dependencies:
```bash
npm install
# or
yarn install
```

3. Run the development server:
```bash
npm run dev
# or
yarn dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser to see the result.

## Project Structure

```
mitali-portfolio-/
├── app/                    # Next.js app directory
│   ├── layout.tsx         # Root layout component
│   ├── page.tsx           # Home page
│   └── globals.css        # Global styles
├── public/                # Static assets (images, videos)
├── components/            # Reusable components
├── package.json           # Project dependencies
├── next.config.js         # Next.js configuration
└── tailwind.config.js     # Tailwind CSS configuration
```

## Building for Production

```bash
npm run build
npm start
```

## Deployment on Vercel

This project is optimized for deployment on Vercel. Simply connect your GitHub repository to Vercel and it will automatically deploy on every push to the main branch.

[Deploy on Vercel](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme)

## Customization

### Adding Images

Place your portfolio images in the `public/` directory and reference them in your components:

```tsx
<img src="/your-image.jpg" alt="Description" />
```

### Styling

This project uses Tailwind CSS. Edit `tailwind.config.js` to customize colors and other design elements.

### Metadata

Update the metadata in `app/layout.tsx` to customize the site title and description.

## Technologies Used

- **Framework:** Next.js 14
- **Styling:** Tailwind CSS
- **Language:** TypeScript
- **Deployment:** Vercel

## License

This project is private and owned by Mitali.

## Support

For issues or questions, please open an issue on GitHub.
