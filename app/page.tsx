'use client'

export default function Home() {
  return (
    <div className="min-h-screen bg-black text-white">
      {/* Header */}
      <header className="border-b border-gray-800">
        <div className="max-w-7xl mx-auto px-6 py-8">
          <h1 className="text-4xl font-bold">Mitali</h1>
          <p className="text-gray-400 mt-2">Photographer & Visual Creator</p>
        </div>
      </header>

      {/* Hero Section */}
      <section className="max-w-7xl mx-auto px-6 py-16">
        <div className="text-center mb-16">
          <h2 className="text-5xl font-bold mb-4">Welcome to My Portfolio</h2>
          <p className="text-xl text-gray-400">
            Capturing moments, creating memories
          </p>
        </div>

        {/* Photo Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {/* Sample Gallery Items - Replace with your actual images */}
          <div className="group relative overflow-hidden rounded-lg bg-gray-900 aspect-square cursor-pointer hover:shadow-lg transition-shadow">
            <div className="w-full h-full bg-gradient-to-br from-gray-800 to-gray-900 flex items-center justify-center">
              <span className="text-gray-500">Gallery Item 1</span>
            </div>
          </div>
          <div className="group relative overflow-hidden rounded-lg bg-gray-900 aspect-square cursor-pointer hover:shadow-lg transition-shadow">
            <div className="w-full h-full bg-gradient-to-br from-gray-800 to-gray-900 flex items-center justify-center">
              <span className="text-gray-500">Gallery Item 2</span>
            </div>
          </div>
          <div className="group relative overflow-hidden rounded-lg bg-gray-900 aspect-square cursor-pointer hover:shadow-lg transition-shadow">
            <div className="w-full h-full bg-gradient-to-br from-gray-800 to-gray-900 flex items-center justify-center">
              <span className="text-gray-500">Gallery Item 3</span>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-gray-800 mt-20">
        <div className="max-w-7xl mx-auto px-6 py-8 text-center text-gray-400">
          <p>&copy; 2024 Mitali Portfolio. All rights reserved.</p>
        </div>
      </footer>
    </div>
  )
}
