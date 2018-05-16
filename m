Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from NDJSVNPF103.ndc.nasa.gov ([198.117.1.153]:43458 "EHLO
        ndjsvnpf103.ndc.nasa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbeEPUEC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 16:04:02 -0400
Received: from ndjsppt204.ndc.nasa.gov (NDJSPPT204.ndc.nasa.gov [198.117.1.146])
        by ndjsvnpf103.ndc.nasa.gov (Postfix) with ESMTP id C96904007E41
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2018 14:56:35 -0500 (CDT)
Received: from pps.filterd (ndjsppt204.ndc.nasa.gov [127.0.0.1])
        by ndjsppt204.ndc.nasa.gov (8.16.0.22/8.16.0.22) with SMTP id w4GJroDp038687
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2018 14:56:35 -0500
Received: from ndjscht112.ndc.nasa.gov (ndjscht112-sc.ndc.nasa.gov [198.117.1.182])
        by ndjsppt204.ndc.nasa.gov with ESMTP id 2j0q3420bd-1
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2018 14:56:35 -0500
From: "Lansdowne, Chatwin (JSC-EV811)" <chatwin.lansdowne-1@nasa.gov>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: rtl8812au with hostapd uses only one antenna of Netis WF2190 AC1200
 (2x2)
Date: Wed, 16 May 2018 19:56:35 +0000
Message-ID: <4F8D997428F87449A40ACFEC13A154CE0AC927FA@NDJSMBX102.ndc.nasa.gov> (sfid-20180516_220406_303233_9D234D82)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SSBhbSB1c2luZyB0aGUgTmV0aXMgV0YyMTkwIEFDMTIwMCBVU0IgV2lGaSBhZGFwdGVyIHdpdGgg
ZHJpdmVyIHJ0bDg4MTJhdS1tYXN0ZXIgaW4gY29uanVuY3Rpb24gd2l0aCB0aGUgcGF0Y2ggaG9z
dGFwZC1ydGw4NzF4ZHJ2LW1hc3Rlci4gIGh0dHBzOi8vd2lraWRldmkuY29tL3dpa2kvTmV0aXNf
V0YyMTkwIA0KDQpXaGVuIHRoZSBOZXRpcyBpcyBjb25maWd1cmVkIGFzIGEgY2xpZW50LCBib3Ro
IGFudGVubmFzIGhhdmUgdHJhbnNtaXQgcG93ZXIgYWJvdXQgKzEzZEJtLiAgDQpXaGVuIHRoZSBO
ZXRpcyBpcyBjb25maWd1cmVkIGFzIEFQLCBvbmUgYW50ZW5uYSAgaGFzIHRyYW5zbWl0IHBvd2Vy
IGFib3V0ICsxM2RCbSBhbmQgdGhlIG90aGVyIGhhcyBubyB0cmFuc21pdCBwb3dlci4NClRoaXMg
aXMgcmVwZWF0YWJsZSBiZXR3ZWVuIHVuaXRzIChzYW1lIGRlYWQgYW50ZW5uYSBhbHdheXMpLCBh
bmQgaGFyZHdhcmUgZnVuY3Rpb25hbGl0eSBpcyByZXN0b3JlZCBieSByZXR1cm5pbmcgdG8gY2xp
ZW50IG1vZGUuDQoNCklzIHRoZSBsb3NzIG9mIGZ1bmN0aW9uIGluIG9uZSBhbnRlbm5hIGEgc29m
dHdhcmUgbWlzY29uZmlndXJhdGlvbj8gIE9yIGluY29tcGxldGUgZnVuY3Rpb25hbGl0eSBpbiB0
aGUgcnRsODgxMmF1IGRyaXZlcj8NCg==
