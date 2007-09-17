Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:20336 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbXIQEs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 00:48:29 -0400
Received: by py-out-1112.google.com with SMTP id u77so2939063pyb
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 21:48:28 -0700 (PDT)
Message-ID: <43e72e890709162148q25586319h15890e01e69d212a@mail.gmail.com>
Date: Mon, 17 Sep 2007 00:48:27 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] Correct ath5k Kconfig depends
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_11712_20259574.1190004507701"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_11712_20259574.1190004507701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch correct's ath5k's Kconfig depends line by making it depend
on WLAN_80211 and also for now marks it EXPERIMENTAL. This patch
applies to the ath5k branch of wireless-dev.

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com

 drivers/net/wireless/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-

  Luis

------=_Part_11712_20259574.1190004507701
Content-Type: text/x-patch; name="fix-ath5k-kconfig.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="fix-ath5k-kconfig.diff"
X-Attachment-Id: f_f6ohxdhb

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL0tjb25maWcgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9LY29uZmlnCmluZGV4IDA3OTdjY2IuLmQ3NGViMGEgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL0tjb25maWcKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvS2NvbmZp
ZwpAQCAtNTUyLDggKzU1Miw3IEBAIGNvbmZpZyBSVEw4MTg3CiAKIGNvbmZpZyBBVEg1SwogCXRy
aXN0YXRlICJBdGhlcm9zIDV4eHggd2lyZWxlc3MgY2FyZHMgc3VwcG9ydCIKLQlkZXBlbmRzIG9u
IE1BQzgwMjExCi0JZGVwZW5kcyBvbiBQQ0kKKwlkZXBlbmRzIG9uIFBDSSAmJiBNQUM4MDIxMSAm
JiBXTEFOXzgwMjExICYmIEVYUEVSSU1FTlRBTAogCWRlZmF1bHQgbQogCS0tLWhlbHAtLS0KIAkg
IFRoaXMgbW9kdWxlIGFkZHMgc3VwcG9ydCBmb3IgYXRoZXJvcyA1eHh4IChlLmcuIDUyMTIpIHdp
cmVsZXNzCg==
------=_Part_11712_20259574.1190004507701--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
