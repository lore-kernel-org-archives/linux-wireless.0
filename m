Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:57875 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751804Ab3JHNDT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 09:03:19 -0400
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 17479-03 for <linux-wireless@vger.kernel.org>;
 Tue,  8 Oct 2013 14:03:15 +0100 (BST)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH] mac80211: port CCMP to cryptoapi's CCM driver
Date: Tue, 8 Oct 2013 14:01:36 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B737B@saturn3.aculab.com> (sfid-20131008_150322_457426_CDD68F64)
In-Reply-To: <1381233152.13359.10.camel@jlt4.sipsolutions.net>
References: <1381231915-24232-1-git-send-email-ard.biesheuvel@linaro.org> (sfid-20131008_133333_304168_2D31449F) <1381233152.13359.10.camel@jlt4.sipsolutions.net>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Ard Biesheuvel" <ard.biesheuvel@linaro.org>
Cc: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<patches@linaro.org>, <linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBIbW0sIHRoYW5rcyBJIGd1ZXNzLiBJJ2xsIG5lZWQgdG8gcmV2aWV3IHRoaXMgaW4gbW9yZSBk
ZXRhaWwsIGJ1dCBJIGhhdmUNCj4gYSBxdWVzdGlvbiBmaXJzdDoNCj4gDQo+ID4gKwkvKiBhbGxv
Y2F0ZSB0aGUgdmFyaWFibGUgc2l6ZWQgYWVhZF9yZXF1ZXN0IG9uIHRoZSBzdGFjayAqLw0KPiA+
ICsJaW50IGwgPSBESVZfUk9VTkRfVVAoY3J5cHRvX2FlYWRfcmVxc2l6ZSh0Zm0pLA0KPiA+ICsJ
CQkgICAgIHNpemVvZihzdHJ1Y3QgYWVhZF9yZXF1ZXN0KSk7DQo+ID4gKwlzdHJ1Y3QgYWVhZF9y
ZXF1ZXN0IHJlcVsxICsgbF07DQo+IA0KPiBUaGlzIGxvb2tzIGEgYml0IG9kZCwgd2h5IHJvdW5k
IHVwIGZpcnN0IGFuZCB0aGVuIGFkZCBvbmU/IFdoeSBldmVuDQo+IGJvdGhlciB1c2luZyBhIHN0
cnVjdCBhcnJheSByYXRoZXIgdGhhbiBzb21lIGxvY2FsIHN0cnVjdCBsaWtlDQoNCklzIGl0IGV2
ZW4gYSBnb29kIGlkZWEgdG8gYmUgYWxsb2NhdGluZyB2YXJpYWJsZSBzaXplZCBpdGVtcw0Kb24g
dGhlIGtlcm5lbCBzdGFjaz8NCg0KVGhlcmUgaGFzIHRvIGJlIGVub3VnaCBzdGFjayBhdmFpbGFi
bGUgZm9yIHRoZSBtYXhpbXVtIG51bWJlcg0Kb2YgZW50cmllcyAtIHNvIHRoZXJlIGlzIGxpdHRs
ZSBwb2ludCBpbiBkeW5hbWljYWxseSBzaXppbmcgaXQuDQoNCglEYXZpZA0KDQo=
