Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:40802 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbZLXUMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 15:12:16 -0500
Received: by iwn1 with SMTP id 1so5940857iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 24 Dec 2009 12:12:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1261658303.28729.4.camel@johannes.local>
References: <1261616609-518-1-git-send-email-lrodriguez@atheros.com>
	<1261616609-518-3-git-send-email-lrodriguez@atheros.com> <1261658303.28729.4.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 24 Dec 2009 12:11:56 -0800
Message-ID: <43e72e890912241211s711c01ado847c34d447f22d65@mail.gmail.com>
Subject: Re: [PATCH 2/5] mac80211: fix propagation of failed hardware
	reconfigurations
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCBEZWMgMjQsIDIwMDkgYXQgNDozOCBBTSwgSm9oYW5uZXMgQmVyZwo8am9oYW5uZXNA
c2lwc29sdXRpb25zLm5ldD4gd3JvdGU6Cj4gT24gV2VkLCAyMDA5LTEyLTIzIGF0IDIwOjAzIC0w
NTAwLCBMdWlzIFIuIFJvZHJpZ3VleiB3cm90ZToKPgo+PiDCoCDCoCDCoCAvKiByZXN0YXJ0IGhh
cmR3YXJlICovCj4+IMKgIMKgIMKgIGlmIChsb2NhbC0+b3Blbl9jb3VudCkgewo+PiArIMKgIMKg
IMKgIMKgIMKgIMKgIC8qCj4+ICsgwqAgwqAgwqAgwqAgwqAgwqAgwqAqIFVwb24gcmVzdW1lIGhh
cmR3YXJlIGNhbiBzb21ldGltZXMgYmUgZ29vZnkgZHVlIHRvCj4+ICsgwqAgwqAgwqAgwqAgwqAg
wqAgwqAqIHZhcmlvdXMgcGxhdGZvcm0gLyBkcml2ZXIgLyBidXMgaXNzdWVzLCBzbyByZXN0YXJ0
aW5nCj4+ICsgwqAgwqAgwqAgwqAgwqAgwqAgwqAqIHRoZSBkZXZpY2UgbWF5IGF0IHRpbWVzIG5v
dCB3b3JrIGltbWVkaWF0ZWx5LiBQcm9wYWdhdGUKPj4gKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCog
dGhlIGVycm9yLgo+PiArIMKgIMKgIMKgIMKgIMKgIMKgIMKgKi8KPj4gwqAgwqAgwqAgwqAgwqAg
wqAgwqAgcmVzID0gZHJ2X3N0YXJ0KGxvY2FsKTsKPj4gKyDCoCDCoCDCoCDCoCDCoCDCoCBpZiAo
cmVzKSB7Cj4+ICsgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgV0FSTihsb2NhbC0+c3Vz
cGVuZGVkLCAiSGFyd2FyZSBiZWNhbWUgdW5hdmFpbGFibGUgIgo+PiArIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgInVwb24gcmVzdW1lIGxpa2VseSBkdWUgdG8gYSBidWcg
b24gbWFjODAyMTEsICIKPj4gKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCJ5b3VyIGRyaXZlciBvciBhIGJ1cyBpc3N1ZVxuIik7Cj4+ICsgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgcmV0dXJuIHJlczsKPj4gKyDCoCDCoCDCoCDCoCDCoCDCoCB9Cj4KPiBJIG9i
amVjdCB0byB0aGUgd29yZGluZyAtLSBob3cgd291bGQgdGhpcyBiZSBhIG1hYzgwMjExIGJ1Zz8g
OikKCldlbGwgaXQgd2FzIGluIHRoZSBmaXJzdCBwbGFjZSwgc2Vjb25kLCBpZiBhbm90aGVyIGJ1
ZyBpcyBsdXJraW5nIHdlCmFyZSBsaWtlbHkgdG8gZmluZCBpdCB0aGVyZS4gQXJlIHlvdSAxMDAl
IHN1cmUgbm90aGluZyBlbHNlIHdpbGwgY3JlZXAKdXA/CgogIEx1aXMK
