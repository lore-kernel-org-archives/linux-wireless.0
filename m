Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65051 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab0DAXFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 19:05:23 -0400
Received: by vws13 with SMTP id 13so335530vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 16:05:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1270156270-7550-2-git-send-email-zajec5@gmail.com>
References: <1270156270-7550-2-git-send-email-zajec5@gmail.com>
Date: Thu, 1 Apr 2010 18:05:22 -0500
Message-ID: <m2y2e59e6971004011605oc44de860q87948992252fbac2@mail.gmail.com>
Subject: Re: [PATCH] b43: N-PHY: fix copy&paste typo
From: "richardvoigt@gmail.com" <richardvoigt@gmail.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, Myhailo Danylenko <isbear@ukrpost.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RG9lcyBhbnlib2R5IGVsc2UgdGhpbmsgYWxsIHRoZSBtYWdpYyBudW1iZXJzIG1ha2UgdGhpcyBj
b2RlIGhhcmQgdG8gdW5kZXJzdGFuZD8KCjIwMTAvNC8xIFJhZmHFgiBNacWCZWNraSA8emFqZWM1
QGdtYWlsLmNvbT46Cj4gUmVwb3J0ZWQtYnk6IE15aGFpbG8gRGFueWxlbmtvIDxpc2JlYXJAdWty
cG9zdC5uZXQ+Cj4gU2lnbmVkLW9mZi1ieTogUmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwu
Y29tPgo+IC0tLQo+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3BoeV9uLmMgfCDCoCDCoDIg
Ky0KPiDCoDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQo+
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9waHlfbi5jIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYjQzL3BoeV9uLmMKPiBpbmRleCA2ZmQxNDBhLi4yYWUyNDQ1IDEwMDY0
NAo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9waHlfbi5jCj4gKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYjQzL3BoeV9uLmMKPiBAQCAtMjc5MCw3ICsyNzkwLDcgQEAgc3RhdGlj
IGludCBiNDNfbnBoeV9jYWxfdHhfaXFfbG8oc3RydWN0IGI0M193bGRldiAqZGV2LAo+IMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfQo+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgYjQzX250YWJfd3JpdGVfYnVsayhkZXYsIEI0M19OVEFCMTYoMTUsIDg4KSwg
NCwKPiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoGJ1ZmZlcik7Cj4gLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBiNDNfbnRhYl93cml0ZV9idWxrKGRldiwgQjQzX05UQUIxNigxNSwgMTAxKSwgMiwK
PiArIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGI0M19udGFiX3JlYWRfYnVsayhk
ZXYsIEI0M19OVEFCMTYoMTUsIDEwMSksIDIsCj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBidWZmZXIpOwo+IMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgYjQzX250YWJfd3JpdGVfYnVsayhkZXYs
IEI0M19OVEFCMTYoMTUsIDg1KSwgMiwKPiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGJ1ZmZlcik7Cj4gLS0KPiAx
LjYuNC4yCj4KPgo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCj4gYjQzLWRldiBtYWlsaW5nIGxpc3QKPiBiNDMtZGV2QGxpc3RzLmluZnJhZGVhZC5vcmcK
PiBodHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2I0My1kZXYKPgo=
