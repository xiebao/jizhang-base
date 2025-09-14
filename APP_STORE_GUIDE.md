# XMoneyNote - App Store Submission Guide

## Quick Start Guide

### 1. App Store Connect Setup

1. **Login to App Store Connect**
   - Go to https://appstoreconnect.apple.com
   - Login with your Apple Developer account

2. **Create New App**
   - Click "My Apps" → "+" → "New App"
   - Fill in the following information:
     - **Name**: XMoneyNote
     - **Primary Language**: English
     - **Bundle ID**: com.jizhang.goodgood
     - **SKU**: xmoney-note-001
     - **User Access**: Full Access

### 2. App Information

Fill in the following in App Store Connect:

**App Information Tab:**
- **Name**: XMoneyNote
- **Subtitle**: Personal Finance Tracker
- **Category**: Finance
- **Content Rights**: No
- **Age Rating**: 4+ (Complete the questionnaire)

**Pricing and Availability:**
- **Price**: Free
- **Availability**: All countries or select specific countries

### 3. App Store Listing

**App Store Tab:**
- **App Description**: Use the description from APP_STORE_METADATA.md
- **Keywords**: finance, money, budget, expense, income, tracker, personal, financial, management, spending, balance, categories, statistics, charts, privacy, offline, secure
- **Support URL**: https://xmoney-note.com/support
- **Marketing URL**: https://xmoney-note.com
- **Privacy Policy URL**: https://xmoney-note.com/privacy

**App Review Information:**
- **Demo Account**: 
  - Username: zhanxiao
  - Password: 123456
- **Review Notes**: 
  ```
  XMoneyNote is a personal finance tracking app. 
  Test account: zhanxiao / 123456
  All data is stored locally on device.
  No in-app purchases or ads.
  ```

### 4. Screenshots Required

Upload screenshots for the following devices:
- **iPhone 6.7" Display** (iPhone 15 Pro Max, 14 Pro Max, etc.)
- **iPhone 6.5" Display** (iPhone 11 Pro Max, XS Max, etc.)
- **iPhone 5.5" Display** (iPhone 8 Plus, 7 Plus, etc.)

Required screenshots:
1. Home screen with transaction list
2. Add transaction screen
3. Statistics screen with charts
4. Profile/settings screen
5. Login screen

### 5. App Icon

- **Size**: 1024x1024 pixels
- **Format**: PNG
- **Design**: Clean, modern design with wallet/money theme
- **No transparency**: Solid background required

### 6. Build Upload

1. **Archive the App**
   ```bash
   flutter build ios --release
   ```

2. **Upload via Xcode**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select "Any iOS Device" as target
   - Product → Archive
   - Distribute App → App Store Connect
   - Upload

3. **Or Upload via Application Loader**
   - Build IPA file
   - Use Application Loader to upload

### 7. Version Information

**Version Tab:**
- **Version**: 1.0.0
- **Copyright**: © 2025 XMoneyNote Development Team
- **Release Notes**: 
  ```
  Initial release of XMoneyNote
  - Track income and expenses
  - Visual statistics and charts
  - Custom categories
  - Local data storage for privacy
  - Dark/Light theme support
  ```

### 8. Final Review

Before submitting:
- [ ] All required information filled
- [ ] Screenshots uploaded
- [ ] App icon uploaded
- [ ] Build uploaded successfully
- [ ] Demo account works
- [ ] Privacy policy accessible
- [ ] Terms of service accessible

### 9. Submit for Review

1. Click "Submit for Review"
2. Confirm all information is correct
3. Wait for Apple's review (typically 24-48 hours)

## Important Notes

### Privacy Policy Requirements
- Must be accessible via URL
- Must clearly state what data is collected
- Must explain how data is used
- Must mention data sharing practices
- Must include contact information

### App Store Guidelines Compliance
- No misleading functionality
- No placeholder content
- All features must work as described
- No crashes or bugs
- Proper age rating
- Appropriate content

### Common Rejection Reasons
1. **Crashes**: App crashes during testing
2. **Incomplete**: Missing required information
3. **Misleading**: App doesn't match description
4. **Privacy**: Missing or inadequate privacy policy
5. **Guidelines**: Violates App Store guidelines

### After Submission
- Monitor App Store Connect for status updates
- Respond to any review feedback promptly
- Be prepared to fix issues and resubmit
- Plan for app updates and maintenance

## Contact Information

For questions about this submission:
- **Email**: support@xmoney-note.com
- **Developer**: XMoneyNote Development Team

---

**Remember**: Keep all your documentation updated and ensure your app meets Apple's App Store Review Guidelines before submitting.
