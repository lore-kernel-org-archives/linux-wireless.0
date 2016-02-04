Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out4.electric.net ([192.162.216.192]:54957 "EHLO
	smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbcBDJwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:52:00 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: 'Larry Finger' <Larry.Finger@lwfinger.net>,
	ByeoungWook Kim <quddnr145@gmail.com>
CC: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"chaoming_li@realsil.com.cn" <chaoming_li@realsil.com.cn>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] rtlwifi: Fix improve function 'rtl_addr_delay()' in
 core.c
Date: Thu, 4 Feb 2016 09:48:34 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CCD61C8@AcuExch.aculab.com> (sfid-20160204_105248_488499_909AAEB8)
References: <20160203015953.GA13562@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D1CCD5486@AcuExch.aculab.com>
 <CAOxTRzpO4mx361GqA+W39bxSfbOCaiLw320S-aph1v1OGJ0FYw@mail.gmail.com>
 <56B258B2.6090802@lwfinger.net>
In-Reply-To: <56B258B2.6090802@lwfinger.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RnJvbTogTGFycnkgRmluZ2VyDQo+IFNlbnQ6IDAzIEZlYnJ1YXJ5IDIwMTYgMTk6NDUNCi4uLg0K
PiBUaGUgcGVyZm9ybWFuY2Ugd2lsbCBkZXBlbmQgb24gd2hlcmUgeW91IHNhdGlzZnkgdGhlIGNv
bmRpdGlvbi4gQWxsIHN3aXRjaCBjYXNlcw0KPiBoYXZlIHRoZSBzYW1lIGV4ZWN1dGlvbiB0aW1l
LCBidXQgaW4gdGhlIGlmIC4uIGVsc2UgaWYgLi4gZWxzZSBmb3JtLCB0aGUgZWFybGllcg0KPiB0
ZXN0cyBleGVjdXRlIG1vcmUgcXVpY2tseS4gSSdtIG5vdCBzdXJlIHRoYXQgb25lIGNhbiBtYWtl
IGFueSBibGFua2V0IHN0YXRlbWVudA0KPiBhYm91dCBwZXJmb3JtYW5jZS4gQ2VydGFpbmx5LCB0
aGUgc3dpdGNoIHZlcnNpb24gd2lsbCBiZSBsYXJnZXIuIEZvciBhIHN3aXRjaA0KPiB3aXRoIDgg
Y2FzZXMgcGx1cyBkZWZhdWx0LCB0aGUgb2JqZWN0IGNvZGUgaWYgNDMgYnl0ZXMgbGFyZ2VyIHRo
YW4gdGhlIG5lc3RlZA0KPiBpZnMgaW4gYSB0ZXN0IHByb2dyYW0gdGhhdCBJIGNyZWF0ZWQuIFRo
YXQgaXMgYSBzaWduaWZpY2FudCBwZW5hbHR5Lg0KDQpUaGVyZSBpcyBhbHNvIHRoZSBwZW5hbHR5
IG9mIHRoZSAobGlrZWx5KSBkYXRhIGNhY2hlIG1pc3MgcmVhZGluZyB0aGUganVtcCB0YWJsZS4N
CkJ1dCBnaXZlbiB0aGlzIGNvZGUgaXMgYWxsIGFib3V0IGdlbmVyYXRpbmcgYSB2YXJpYWJsZSBk
ZWxheSB0aGUgZXhlY3V0aW9uDQpzcGVlZCBpcyBwcm9iYWJseSBpcnJlbGV2YW50Lg0KDQpJdCB3
b3VsZCBiZSBtdWNoIG1vcmUgaW50ZXJlc3RpbmcgaWYgdGhlIGRlbGF5IGNvdWxkIGJlIGNoYW5n
ZWQgZm9yIHNsZWVwcy4NCg0KCURhdmlkDQo=
