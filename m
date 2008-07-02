Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:38179 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYGBHx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 03:53:58 -0400
Received: by py-out-1112.google.com with SMTP id p76so112220pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jul 2008 00:53:57 -0700 (PDT)
Message-ID: <eb3ff54b0807020053h1b34a8e9p476f7cb149fd6805@mail.gmail.com> (sfid-20080702_095401_977617_CCE8CD8C)
Date: Wed, 2 Jul 2008 10:53:57 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 1/1] mac80211: remove MAC80211_DEBUG from net/mac80211/Kconfig.
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_965_12739909.1214985237332"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_965_12739909.1214985237332
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
This patch removes MAC80211_DEBUG from /net/mac80211/Kconfig
(in MAC80211_DEBUG_COUNTERS config entry), and replaces
MAC80211_DEBUG_MENU instead of MAC80211_DEBUG
(in MAC80211_VERBOSE_SPECT_MGMT_DEBUG config entry).

(for wireless-next-2.6 tree)

Regards,
Rami Rosen

Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_965_12739909.1214985237332
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fi5msarg0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9LY29uZmlnIGIvbmV0L21hYzgwMjExL0tjb25maWcK
aW5kZXggMTFhMWU3Zi4uNDBmMWFkZCAxMDA2NDQKLS0tIGEvbmV0L21hYzgwMjExL0tjb25maWcK
KysrIGIvbmV0L21hYzgwMjExL0tjb25maWcKQEAgLTIwNyw3ICsyMDcsNiBAQCBjb25maWcgTUFD
ODAyMTFfTE9XVFhfRlJBTUVfRFVNUAogCiBjb25maWcgTUFDODAyMTFfREVCVUdfQ09VTlRFUlMK
IAlib29sICJFeHRyYSBzdGF0aXN0aWNzIGZvciBUWC9SWCBkZWJ1Z2dpbmciCi0JZGVwZW5kcyBv
biBNQUM4MDIxMV9ERUJVRwogCWRlcGVuZHMgb24gTUFDODAyMTFfREVCVUdfTUVOVQogCWRlcGVu
ZHMgb24gTUFDODAyMTFfREVCVUdGUwogCS0tLWhlbHAtLS0KQEAgLTIxOSw3ICsyMTgsNyBAQCBj
b25maWcgTUFDODAyMTFfREVCVUdfQ09VTlRFUlMKIAogY29uZmlnIE1BQzgwMjExX1ZFUkJPU0Vf
U1BFQ1RfTUdNVF9ERUJVRwogCWJvb2wgIlZlcmJvc2UgU3BlY3RydW0gTWFuYWdlbWVudCAoSUVF
RSA4MDIuMTFoKWRlYnVnZ2luZyIKLQlkZXBlbmRzIG9uIE1BQzgwMjExX0RFQlVHCisJZGVwZW5k
cyBvbiBNQUM4MDIxMV9ERUJVR19NRU5VCiAJLS0taGVscC0tLQogCSAgU2F5IFkgaGVyZSB0byBw
cmludCBvdXQgdmVyYm9zZSBTcGVjdHJ1bSBNYW5hZ2VtZW50IChJRUVFIDgwMi4xMWgpCiAJICBk
ZWJ1ZyBtZXNzYWdlcy4K
------=_Part_965_12739909.1214985237332--
