# KidsMath Deployment Guide

## HTML Legal Documents Deployment

### Files to Upload to Your Website

You now have ready-to-deploy HTML files for your legal documents:

1. **`privacy-policy.html`** - Complete privacy policy
2. **`terms-of-service.html`** - Complete terms of service  
3. **`legal-documents.html`** - Index page (optional)

### Recommended Website Structure

```
yourdomain.com/
├── privacy-policy.html
├── terms-of-service.html
└── legal-documents.html (optional)
```

### URLs for App Store Submission

Use these URLs in your app store submissions:

- **Privacy Policy URL:** `https://yourdomain.com/privacy-policy.html`
- **Terms of Service URL:** `https://yourdomain.com/terms-of-service.html`

### Before Going Live

1. **Update Contact Information**
   - Replace `privacy@kidsmath.app` with your actual email
   - Replace `support@kidsmath.app` with your actual email
   - Add your business address
   - Update jurisdiction in terms of service

2. **Test the Pages**
   - Ensure all pages load correctly
   - Check mobile responsiveness
   - Verify all internal links work
   - Test on different browsers

3. **SEO Optimization (Optional)**
   - Add meta descriptions
   - Include relevant keywords
   - Ensure fast loading times

### Hosting Options

#### Free Options
- **GitHub Pages** - Host directly from your repository
- **Netlify** - Drag and drop deployment
- **Vercel** - Simple static site hosting

#### Paid Options
- **Your existing website** - Upload to current hosting
- **AWS S3** - Static website hosting
- **Google Cloud Storage** - Static website hosting

### GitHub Pages Setup (Free Option)

1. Create a new repository called `kidsmath-legal`
2. Upload the HTML files
3. Enable GitHub Pages in repository settings
4. Your URLs will be:
   - `https://yourusername.github.io/kidsmath-legal/privacy-policy.html`
   - `https://yourusername.github.io/kidsmath-legal/terms-of-service.html`

### App Store Submission Checklist

#### Google Play Console
- [ ] Upload APK/AAB file
- [ ] Complete "Data safety" section
- [ ] Add Privacy Policy URL
- [ ] Set target age group to "Ages 5 & under" or "Ages 6-8"
- [ ] Select "Designed for Families" program
- [ ] Complete content rating questionnaire

#### Apple App Store Connect
- [ ] Upload IPA file via Xcode or Application Loader
- [ ] Complete "App Privacy" section
- [ ] Add Privacy Policy URL
- [ ] Set age rating appropriately
- [ ] Add screenshots and app description
- [ ] Submit for review

### Content Updates

When you need to update the legal documents:

1. Update the HTML files
2. Change the "Last Updated" dates
3. Re-upload to your website
4. Consider notifying users through app updates

### Legal Compliance Notes

- Documents are COPPA compliant
- GDPR compliant for international users
- Includes all required disclosures for children's apps
- Covers data collection, usage, and sharing practices
- Includes parental rights and contact information

### Support

If you need help with deployment or have questions about the legal documents:

1. Check the `LEGAL_DOCUMENTS_README.md` file
2. Review app store documentation
3. Consider consulting with a legal professional for specific compliance questions

### Quick Start Commands

If using a simple HTTP server for testing:

```bash
# Navigate to the project directory
cd kids_math_game

# Start a simple HTTP server (Python 3)
python3 -m http.server 8000

# Or with Node.js (if you have http-server installed)
npx http-server

# Then visit: http://localhost:8000/legal-documents.html
```

This allows you to test the pages locally before deploying to your website.