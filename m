Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38692 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751846AbdLVGDN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 01:03:13 -0500
Received: from mail-io0-f199.google.com ([209.85.223.199])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1eSGQK-0002eI-Mr
        for linux-wireless@vger.kernel.org; Fri, 22 Dec 2017 06:03:12 +0000
Received: by mail-io0-f199.google.com with SMTP id z195so18842590iof.21
        for <linux-wireless@vger.kernel.org>; Thu, 21 Dec 2017 22:03:12 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/6] wireless-regdb: Add sforshee's x509 certificate
Date: Fri, 22 Dec 2017 00:03:00 -0600
Message-Id: <20171222060303.14478-4-seth.forshee@canonical.com> (sfid-20171222_070345_323089_5D7BA0A9)
In-Reply-To: <20171222060303.14478-1-seth.forshee@canonical.com>
References: <20171222060303.14478-1-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a x509 certificate for sforshee.key.pub.pem. This is the same
certificate which is shipped in the kernel for validating
regulatory database files.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 sforshee.x509.pem | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 sforshee.x509.pem

diff --git a/sforshee.x509.pem b/sforshee.x509.pem
new file mode 100644
index 000000000000..ebd01606d057
--- /dev/null
+++ b/sforshee.x509.pem
@@ -0,0 +1,17 @@
+-----BEGIN CERTIFICATE-----
+MIICpDCCAYwCCQCyjd9HrvnOpzANBgkqhkiG9w0BAQsFADATMREwDwYDVQQDDAhz
+Zm9yc2hlZTAgFw0xNzEwMDYxOTQwMzVaGA8yMTE3MDkxMjE5NDAzNVowEzERMA8G
+A1UEAwwIc2ZvcnNoZWUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC1
+QOOcKIQ5A/I512YsQTgVrH6lg3ElfpB8aN1vP9nXWTiffGpSwgMqLX5m9B6zEnAg
+W9SXMj1xizsbCBcUa2HEV4uWFhz9JNULCfloEYT7ylEM0UUZ2hBEitn+dqn9YC0Y
+CyiVsi3qiJi40VYh8FMf8QJv6Uabk18okA+sNvpoI3FXVvbM0999Ktkbc0XruieF
+73p/pcuAxzA20lPu7Kwe5zHxNqKcY8ZlW38ldWih6tN+AFyaXtggGDJ3BykSZh42
+c+eXBEE3sbFyK/ShKSB8lnkLK9DY3shsP5P7xe54UhEVG3r24miZ5/tGFoTjx6Hm
+4NJG1eHEX6Bm9NrE/5UdAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAIcD2vKCwt2v
+fEQvhtNfTJNIuf4HF7sh9yUjTqoiDBa5c66dRnx12cNJV0e/M7eX7PVAdcBGIvCg
+XZx5E6H/uKMve44GP8i25Goo8jRcIz8ywOatD6zPVXRHc9MBhbcLIlYkfZ8JqQ6G
+njdbnG0C2YzIUGriWfMWBuqyQrVY/rrRgVca77I4iFj2qsQui1on5KXopMpnXKxy
+Z8NvE8MtNXnXiuf11CEwStX2o9l5VvIPEPd90FGTL0f4fUsKhFUSCn1OOx8rL/wo
+s2k04YCAu+KvudYw8R1UhyOZn1EDTEV9AmVzq/3PlMwNOmD9PBQvFjOpIR/LULGP
+A+6gZqkWeRQ=
+-----END CERTIFICATE-----
-- 
2.14.1
