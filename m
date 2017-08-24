Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:30066 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753362AbdHXO1R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 10:27:17 -0400
From: Ryan Hsu <ryanhsu@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k: fix napi_poll budget overflow
Date: Thu, 24 Aug 2017 14:27:02 +0000
Message-ID: <be0d2b7d-e498-64ac-282a-bf23d10a5b18@qti.qualcomm.com> (sfid-20170824_162737_692454_0803E6CA)
References: <1503438242-5657-1-git-send-email-ryanhsu@qti.qualcomm.com>
 <2cd00da66a6847c1829ed9edf7ad7009@euamsexm01a.eu.qualcomm.com>
In-Reply-To: <2cd00da66a6847c1829ed9edf7ad7009@euamsexm01a.eu.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQpPbiAwOC8yNC8yMDE3IDAyOjA3IEFNLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiByeWFuaHN1QHF0
aS5xdWFsY29tbS5jb20gd3JvdGU6DQo+DQo+PiBGcm9tOiBSeWFuIEhzdSA8cnlhbmhzdUBxdGku
cXVhbGNvbW0uY29tPg0KPj4NCj4+IEluIG5hcGlfcG9sbCwgdGhlIGJ1ZGdldCBudW1iZXIgaXMg
dXNlZCB0byBjb250cm9sIHRoZSBhbW91bnQgb2YgcGFja2V0cw0KPj4gd2Ugc2hvdWxkIGhhbmRs
ZSBwZXIgcG9sbCB0byBiYWxhbmNlIHRoZSByZXNvdXJjZSBpbiB0aGUgc3lzdGVtLg0KPj4NCj4+
IEluIHRoZSBsaXN0IG9mIHRoZSBhbXNkdSBwYWNrZXRzIHJlY2VwdGlvbiwgd2UgY2hlY2sgaWYg
dGhlcmUgaXMgYnVkZ2V0DQo+PiBjb3VudCBsZWZ0IGFuZCBoYW5kbGUgdGhlIGNvbXBsZXRlIGxp
c3Qgb2YgdGhlIHBhY2tldHMsIHRoYXQgaXQgd2lsbCBoYXZlDQo+PiBjaGFuY2VzIHRoZSB2ZXJ5
IGxhc3QgbGlzdCB3aWxsIG92ZXIgdGhlIGJ1ZGdldCBsZWZ0b3Zlci4NCj4+DQo+PiBTbyBhZGRp
bmcgb25lIG1vcmUgcGFyYW1ldGVyIC0gYnVkZ2V0X2xlZnQsIHRoaXMgd291bGQgaGVscCB3aGls
ZQ0KPj4gdHJhdmVyc2luZyB0aGUgbGlzdCB0byBhdm9pZCBoYW5kbGluZyBtb3JlIHRoYW4gdGhl
IGJ1ZGdldCBnaXZlbi4NCj4+DQo+PiBSZXBvcnRlZC1ieTogQW5kcmV5IFJ5YWJpbmluIDxhcnlh
YmluaW5AdmlydHVvenpvLmNvbT4NCj4+IEZpeC1zdWdnZXN0ZWQtYnk6IElnb3IgTWl0c3lhbmtv
IDxpZ29yLm1pdHN5YW5rby5vc0BxdWFudGVubmEuY29tPg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6
IFJ5YW4gSHN1IDxyeWFuaHN1QHF0aS5xdWFsY29tbS5jb20+DQo+IFdhcyB0aGVyZSBhIGJ1ZyBy
ZXBvcnQgYWJvdXQgdGhpcz8gSSBjYW4gYWRkIGEgbGluayB0byB0aGF0IGFuZCBtYXliZSBhbHNv
DQo+IGluY2x1ZGUgdGhlIHdhcm5pbmcuDQoNCmh0dHBzOi8vbWFyYy5pbmZvLz9sPWxpbnV4LW5l
dGRldiZtPTE0OTg4NDA0NzgyMzg3MCZ3PTINCg0KLS0gDQpSeWFuIEhzdQ0K
