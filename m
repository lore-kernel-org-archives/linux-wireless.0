Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:39230 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbcADJgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 04:36:10 -0500
From: Hante Meuleman <meuleman@broadcom.com>
To: Carlo Caione <carlo@caione.org>,
	Arend van Spriel <aspriel@gmail.com>
CC: Arend Van Spriel <arend@broadcom.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [BISECTED] brcmfmac issue since 4.3.0-rc3
Date: Mon, 4 Jan 2016 09:36:09 +0000
Message-ID: <F51492713EF10846800D8C0ED37A7DCE019C6610@SJEXCHMB15.corp.ad.broadcom.com> (sfid-20160104_103613_627724_B989D9C0)
References: <CAOQ7t2bEs2UhxfWUCs7TBwidw2JKCKLmeUzcYjng4f5p4Wr-Mw@mail.gmail.com>
	<567D1268.70709@gmail.com>
 <CAOQ7t2aJr6Ub+7t1B7XfJvJb_p2AMV+77MsiozZz73uQaxOVnw@mail.gmail.com>
In-Reply-To: <CAOQ7t2aJr6Ub+7t1B7XfJvJb_p2AMV+77MsiozZz73uQaxOVnw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgQ2FybG8NCg0KVGhlIGV4cGVjdGlvbiB3YXMgbGlrZWx5IGZpeGVkIHdpdGggYSBwYXRjaCB3
aXRoIHRoZSB0aXRsZToNCg0KYnJjbWZtYWM6IEZpeCBkb3VibGUgZnJlZSBvbiBleGNlcHRpb24g
YXQgbW9kdWxlIGxvYWQuDQoNClRoZSBjaGFuZ2UgeW91IGZvdW5kIHdoaWNoIGlzIGNhdXNpbmcg
YSBjcmFzaCBjYXVzZWQgYSBkb3VibGUgZnJlZS4gDQoNCkl0IHdvbid0IGZpeCB0aGUgZmlybXdh
cmUgY3Jhc2gsIGJ1dCBpdCB3aWxsIGZpeCB0aGUgc3lzdGVtIGNyYXNoIG9uIGZhaWx1cmUuDQoN
ClJlZ2FyZHMsDQpIYW50ZQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogY2Fy
bG8uY2Fpb25lQGdtYWlsLmNvbSBbbWFpbHRvOmNhcmxvLmNhaW9uZUBnbWFpbC5jb21dIE9uIEJl
aGFsZiBPZiBDYXJsbyBDYWlvbmUNClNlbnQ6IEZyaWRheSwgRGVjZW1iZXIgMjUsIDIwMTUgMTE6
MTYgQU0NClRvOiBBcmVuZCB2YW4gU3ByaWVsDQpDYzogQ2FybG8gQ2Fpb25lOyBIYW50ZSBNZXVs
ZW1hbjsgQXJlbmQgVmFuIFNwcmllbDsga3ZhbG9AY29kZWF1cm9yYS5vcmc7IGxpbnV4LXdpcmVs
ZXNzQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogUmU6IFtCSVNFQ1RFRF0gYnJjbWZtYWMgaXNz
dWUgc2luY2UgNC4zLjAtcmMzDQoNCk9uIEZyaSwgRGVjIDI1LCAyMDE1IGF0IDEwOjU0IEFNLCBB
cmVuZCB2YW4gU3ByaWVsIDxhc3ByaWVsQGdtYWlsLmNvbT4gd3JvdGU6DQo+IEhpIENhcmxvLA0K
Pg0KPiBUaGlzIHNtZWxscyBsaWtlIGEgZmlybXdhcmUgY3Jhc2guIFVwb24gdGhlIGJyY21mX2J1
c19zdGFydCBmYWlsdXJlIHdlDQo+IGJhaWwgb3V0IG9uIHRoZSBwcm9iZS4gSSBzdXNwZWN0IGlu
IHRoZSBlcnJvciBwYXRoIHRoZXJlIGlzIGFuIGlzc3VlDQo+IGludHJvZHVjZWQgKG9yIGV4cG9z
ZWQpIGJ5IHRoZSBtZW50aW9uZWQgcGF0Y2guIERpZCBub3QgbG9vayBmdXJ0aGVyDQo+IGludG8g
aXQgYXMgdGhlIGZhbWlseSBpcyBnaXZpbmcgbWUgdGhlIGFuZ3J5IGxvb2sgZHVyaW5nIHRoZSBo
b2xpZGF5cyA7LSkNCg0KSGkgQXJlbmQsDQpUaGFuayB5b3UgZm9yIHRoZSBxdWljayByZXBseSwg
dGhpcyBjYW4gZGVmaW5pdGVseSB3YWl0IDstKQ0KSGFwcHkgaG9saWRheXMgYW5kIGhhcHB5IG5l
dyB5ZWFyIQ0KDQotLSANCkNhcmxvIENhaW9uZQ0KDQo=
