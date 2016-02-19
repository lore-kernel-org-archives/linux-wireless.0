Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:25932 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1426618AbcBSBrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 20:47:49 -0500
From: "Kim, Leo" <Leo.Kim@atmel.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Cho, Tony" <Tony.Cho@atmel.com>, "Lee, Glen" <Glen.Lee@atmel.com>,
	"Shin, Austin" <Austin.Shin@atmel.com>,
	"Park, Chris" <Chris.Park@atmel.com>,
	"Abozaeid, Adham" <Adham.Abozaeid@atmel.com>,
	"Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
Subject: RE: [PATCH V2 18/24] staging: wilc1000: linux_wlan.c: removes
 unnecessary log messages
Date: Fri, 19 Feb 2016 01:47:02 +0000
Message-ID: <74F3875218FC364C9618AB19CB60E90580049A75@penmbx02.corp.atmel.com> (sfid-20160219_024754_628275_94C2C0A4)
References: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
 <1455795024-26978-18-git-send-email-leo.kim@atmel.com>
 <CAGRGNgXJD1Cu1CdmYZfhqf=Up_v0pA2zw+GthDtJPaVwuV99JQ@mail.gmail.com>
In-Reply-To: <CAGRGNgXJD1Cu1CdmYZfhqf=Up_v0pA2zw+GthDtJPaVwuV99JQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSnVsaWFuLA0KDQpZZXMsIG9uZ29pbmcgcmVtb3ZlIHRoaXMgZnVuY3Rpb24uDQpJIHdpbGwg
YmUgcmVtb3ZpbmcgdGhpcyBmdW5jdGlvbiBmb3IgbmV4dCBwYXRjaC4NClRoYW5rIHlvdSBpbiB5
b3VyIGFkdmljZS4NCg0KwqBUaGFua3MsIEJSDQrCoExlbw0KDQotLS0tLU9yaWdpbmFsIE1lc3Nh
Z2UtLS0tLQ0KRnJvbTogSnVsaWFuIENhbGFieSBbbWFpbHRvOmp1bGlhbi5jYWxhYnlAZ21haWwu
Y29tXSANClNlbnQ6IEZyaWRheSwgRmVicnVhcnkgMTksIDIwMTYgOTo0MSBBTQ0KVG86IEtpbSwg
TGVvIDxMZW8uS2ltQGF0bWVsLmNvbT4NCkNjOiBHcmVnIEtIIDxncmVna2hAbGludXhmb3VuZGF0
aW9uLm9yZz47IGRldmVsQGRyaXZlcmRldi5vc3Vvc2wub3JnOyBsaW51eC13aXJlbGVzcyA8bGlu
dXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnPjsgQ2hvLCBUb255IDxUb255LkNob0BhdG1lbC5j
b20+OyBMZWUsIEdsZW4gPEdsZW4uTGVlQGF0bWVsLmNvbT47IFNoaW4sIEF1c3RpbiA8QXVzdGlu
LlNoaW5AYXRtZWwuY29tPjsgUGFyaywgQ2hyaXMgPENocmlzLlBhcmtAYXRtZWwuY29tPjsgQWJv
emFlaWQsIEFkaGFtIDxBZGhhbS5BYm96YWVpZEBhdG1lbC5jb20+OyBGZXJyZSwgTmljb2xhcyA8
Tmljb2xhcy5GRVJSRUBhdG1lbC5jb20+DQpTdWJqZWN0OiBSZTogW1BBVENIIFYyIDE4LzI0XSBz
dGFnaW5nOiB3aWxjMTAwMDogbGludXhfd2xhbi5jOiByZW1vdmVzIHVubmVjZXNzYXJ5IGxvZyBt
ZXNzYWdlcw0KDQpIaSBMZW8sDQoNCk9uIFRodSwgRmViIDE4LCAyMDE2IGF0IDEwOjMwIFBNLCBM
ZW8gS2ltIDxsZW8ua2ltQGF0bWVsLmNvbT4gd3JvdGU6DQo+IEZyb206IENocmlzIFBhcmsgPGNo
cmlzLnBhcmtAYXRtZWwuY29tPg0KPg0KPiBUaGlzIHBhdGNoIHJlbW92ZXMgdW5uZWNlc3Nhcnkg
bG9nIG1lc3NhZ2VzLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpcyBQYXJrIDxjaHJpcy5wYXJr
QGF0bWVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTGVvIEtpbSA8bGVvLmtpbUBhdG1lbC5jb20+
DQo+IC0tLQ0KPiAgZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL2xpbnV4X3dsYW4uYyB8IDEgLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRpb24oLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93aWxjMTAwMC9saW51eF93bGFuLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2lsYzEw
MDAvbGludXhfd2xhbi5jDQo+IGluZGV4IGE3MzFiNDYuLjY2MGJmNjMgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC9saW51eF93bGFuLmMNCj4gKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dpbGMxMDAwL2xpbnV4X3dsYW4uYw0KPiBAQCAtMjI2LDcgKzIyNiw2IEBAIHN0YXRp
YyB2b2lkIGRlaW5pdF9pcnEoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4NCj4gIHZvaWQgd2ls
Y19kYmcodTggKmJ1ZmYpDQo+ICB7DQo+IC0gICAgICAgUFJJTlRfRChJTklUX0RCRywgIiVkXG4i
LCAqYnVmZik7DQo+ICB9DQoNCkFyZSB5b3Ugc3VyZSB0aGlzIGlzIHJpZ2h0PyBJZiBzbywgd2h5
IG5vdCBqdXN0IHJlbW92ZSB0aGlzIGZ1bmN0aW9uIGVudGlyZWx5Pw0KDQpUaGFua3MsDQoNCi0t
IA0KSnVsaWFuIENhbGFieQ0KDQpFbWFpbDoganVsaWFuLmNhbGFieUBnbWFpbC5jb20NClByb2Zp
bGU6IGh0dHA6Ly93d3cuZ29vZ2xlLmNvbS9wcm9maWxlcy9qdWxpYW4uY2FsYWJ5Lw0K
