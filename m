Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:2687 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761342AbYDLNiO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2008 09:38:14 -0400
Received: by yw-out-2324.google.com with SMTP id 5so357274ywb.1
        for <linux-wireless@vger.kernel.org>; Sat, 12 Apr 2008 06:38:13 -0700 (PDT)
Message-ID: <4800BB38.3090002@gmail.com> (sfid-20080412_143849_342331_EB3E01BC)
Date: Sat, 12 Apr 2008 08:38:00 -0500
From: "Jory A. Pratt" <geekypenguin@gmail.com>
MIME-Version: 1.0
CC: linux-wireless@vger.kernel.org
Subject: [RFC 1/2] mac80211: Patch to prevent mac80211 to clobber injected
 sequence numbers
References: <20080410134810.629048000@sipsolutions.net> <20080410134829.412424000@sipsolutions.net> <Pine.LNX.4.64.0804121050160.28120@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0804121050160.28120@vixen.sonytel.be>
Content-Type: multipart/mixed;
 boundary="------------070708060406050904080903"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070708060406050904080903
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


--------------070708060406050904080903
Content-Type: text/plain;
 name="mac80211-wireless-testing_frag.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="mac80211-wireless-testing_frag.patch"

IyBQYXRjaCB0byBwcmV2ZW50IG1hYzgwMjExIHRvIGNsb2JiZXIgaW5qZWN0ZWQgc2VxdWVu
Y2UgbnVtYmVycwoKZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS90eC5jIGIvbmV0L21hYzgw
MjExL3R4LmMKaW5kZXggZjM1ZWFlYS4uZWYzZTMzZiAxMDA2NDQKLS0tIGEvbmV0L21hYzgw
MjExL3R4LmMKKysrIGIvbmV0L21hYzgwMjExL3R4LmMKQEAgLTI5Miw2ICsyOTIsOSBAQCBp
ZWVlODAyMTFfdHhfaF9zZXF1ZW5jZShzdHJ1Y3QgaWVlZTgwMjExX3R4X2RhdGEgKnR4KQog
ewogICAgICAgIHN0cnVjdCBpZWVlODAyMTFfaGRyICpoZHIgPSAoc3RydWN0IGllZWU4MDIx
MV9oZHIgKil0eC0+c2tiLT5kYXRhOwogCisgICAgICAgaWYgKHVubGlrZWx5KHR4LT5mbGFn
cyAmIElFRUU4MDIxMV9UWFJYRF9UWF9JTkpFQ1RFRCkpCisgICAgICAgICAgICAgICByZXR1
cm4gVFhSWF9DT05USU5VRTsKKwogICAgICAgIGlmIChpZWVlODAyMTFfZ2V0X2hkcmxlbihs
ZTE2X3RvX2NwdShoZHItPmZyYW1lX2NvbnRyb2wpKSA+PSAyNCkKICAgICAgICAgICAgICAg
IGllZWU4MDIxMV9pbmNsdWRlX3NlcXVlbmNlKHR4LT5zZGF0YSwgaGRyKTsK
--------------070708060406050904080903--
