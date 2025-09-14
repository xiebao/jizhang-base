# XMoneyNote - Web Deployment Guide

## Overview

This guide explains how to deploy the XMoneyNote privacy policy and terms of service web pages to make them accessible for App Store submission.

## Files Created

1. **index.html** - Main website homepage
2. **privacy-policy.html** - Privacy policy page
3. **terms-of-service.html** - Terms of service page

## Deployment Options

### Option 1: GitHub Pages (Free)

1. **Create GitHub Repository**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/yourusername/xmoney-note-website.git
   git push -u origin main
   ```

2. **Enable GitHub Pages**
   - Go to repository Settings
   - Scroll to "Pages" section
   - Select "Deploy from a branch"
   - Choose "main" branch and "/ (root)" folder
   - Save settings

3. **Access URLs**
   - Homepage: `https://yourusername.github.io/xmoney-note-website/`
   - Privacy Policy: `https://yourusername.github.io/xmoney-note-website/privacy-policy.html`
   - Terms of Service: `https://yourusername.github.io/xmoney-note-website/terms-of-service.html`

### Option 2: Netlify (Free)

1. **Upload Files**
   - Go to [netlify.com](https://netlify.com)
   - Drag and drop the HTML files to deploy
   - Or connect your GitHub repository

2. **Custom Domain (Optional)**
   - Add your custom domain in Netlify settings
   - Update DNS records as instructed

### Option 3: Vercel (Free)

1. **Deploy via Vercel**
   ```bash
   npm i -g vercel
   vercel --prod
   ```

2. **Access URLs**
   - Vercel will provide a custom URL
   - Example: `https://xmoney-note.vercel.app`

### Option 4: Traditional Web Hosting

1. **Upload Files**
   - Upload all HTML files to your web hosting provider
   - Ensure files are in the root directory or public_html folder

2. **Access URLs**
   - Homepage: `https://yourdomain.com/`
   - Privacy Policy: `https://yourdomain.com/privacy-policy.html`
   - Terms of Service: `https://yourdomain.com/terms-of-service.html`

## App Store Connect Configuration

### Required URLs

Update these URLs in App Store Connect:

1. **Support URL**: `https://yourdomain.com/`
2. **Privacy Policy URL**: `https://yourdomain.com/privacy-policy.html`
3. **Marketing URL**: `https://yourdomain.com/` (optional)

### Example Configuration

```
Support URL: https://xmoney-note.github.io/
Privacy Policy URL: https://xmoney-note.github.io/privacy-policy.html
Marketing URL: https://xmoney-note.github.io/
```

## Customization

### Update Contact Information

Before deploying, update the following in all HTML files:

1. **Email Addresses**
   - Replace `privacy@xmoney-note.com` with your actual email
   - Replace `support@xmoney-note.com` with your actual email

2. **Business Address**
   - Replace `[Your Business Address]` with your actual address

3. **Jurisdiction**
   - Replace `[Your Jurisdiction]` with your actual jurisdiction

### Update Branding

1. **App Name**
   - Ensure "XMoneyNote" is consistent throughout
   - Update if you change the app name

2. **Colors and Styling**
   - Modify CSS variables to match your brand colors
   - Update the gradient backgrounds if desired

## Testing

### Before Deployment

1. **Local Testing**
   ```bash
   # Open files in browser
   open index.html
   open privacy-policy.html
   open terms-of-service.html
   ```

2. **Link Testing**
   - Verify all internal links work correctly
   - Check that privacy policy and terms links are accessible

### After Deployment

1. **URL Testing**
   - Test all URLs in different browsers
   - Verify mobile responsiveness
   - Check loading speed

2. **App Store Integration**
   - Test URLs in App Store Connect
   - Ensure Apple can access the pages
   - Verify content meets App Store requirements

## Security Considerations

### HTTPS Required

- App Store requires HTTPS for all privacy policy and support URLs
- Most hosting providers offer free SSL certificates
- Ensure your URLs use `https://` not `http://`

### Content Validation

- Ensure privacy policy accurately reflects your app's data practices
- Verify terms of service cover all app functionality
- Keep content up to date with app changes

## Maintenance

### Regular Updates

1. **Content Updates**
   - Update privacy policy when app features change
   - Modify terms of service as needed
   - Keep contact information current

2. **Technical Maintenance**
   - Monitor website uptime
   - Update dependencies if using a framework
   - Backup website files regularly

## Troubleshooting

### Common Issues

1. **404 Errors**
   - Check file names and paths
   - Ensure files are in correct directory
   - Verify case sensitivity

2. **SSL Certificate Issues**
   - Contact hosting provider for SSL setup
   - Use Let's Encrypt for free SSL certificates

3. **App Store Rejection**
   - Ensure URLs are accessible
   - Verify content meets App Store guidelines
   - Check that privacy policy is comprehensive

## Support

For questions about web deployment:

- **Email**: support@xmoney-note.com
- **Documentation**: Check hosting provider documentation
- **Community**: GitHub Issues or Stack Overflow

---

**Note**: This guide provides general deployment instructions. Specific steps may vary depending on your chosen hosting provider and technical setup.
