Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16714 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630AbbDPJ7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 05:59:20 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Andreas Fenkart <afenkart@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Date: Thu, 16 Apr 2015 02:59:15 -0700
Subject: RE: [PATCH 2/2] mwifiex: sdio: bug: dead-lock in card reset
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951B16DFC5C2@SC-VEXCH1.marvell.com> (sfid-20150416_115923_677234_1CF0DDC3)
References: <1428916704-9635-1-git-send-email-afenkart@gmail.com>
	<1428916704-9635-2-git-send-email-afenkart@gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951B16DFB8F9@SC-VEXCH1.marvell.com>
 <CALtMJECuDTKCRK9YXfTq0vAWmTm4rbNreE5i37T-H7=c5q=T7A@mail.gmail.com>
In-Reply-To: <CALtMJECuDTKCRK9YXfTq0vAWmTm4rbNreE5i37T-H7=c5q=T7A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgQW5kcmVhcywNCg0KPiAyMDE1LTA0LTEzIDEyOjI3IEdNVCswMjowMCBBbWl0a3VtYXIgS2Fy
d2FyIDxha2Fyd2FyQG1hcnZlbGwuY29tPjoNCj4gPg0KPiA+IFdlIGhhZCByZWNlbnRseSBzdWJt
aXR0ZWQgYSBwYXRjaCB0byBhZGRyZXNzIHRoaXMgaXNzdWUuIFNvIHRoZXNlIHR3bw0KPiBwYXRj
aGVzIHdvbid0IGJlIG5lZWRlZCBub3cuDQo+ID4gaHR0cDovL3d3dy5zcGluaWNzLm5ldC9saXN0
cy9saW51eC13aXJlbGVzcy9tc2cxMzUxNDYuaHRtbA0KPiA+DQo+ID4gQ291bGQgeW91IHBsZWFz
ZSBjaGVjayBhbmQgbGV0IHVzIGtub3cgaWYgeW91IGhhdmUgYW55IHN1Z2dlc3Rpb25zIGZvcg0K
PiBpbXByb3ZlbWVudD8NCj4gDQo+IFRoZXkgd29yayBmb3IgbXkgdXNlIGNhc2U6IDEgYWRhcHRl
ciAvIG5vbi1yZW1vdmFibGUNCj4gDQo+IFByb2JsZW1zIG5vdCBzb2x2ZWQ6DQo+IC0gdGhlIHVz
ZSBvZiBnbG9iYWwgc3RhdGljIHZhcmlhYmxlIGlzIHJhY3kgaW4gY2FzZSB0aGVyZSB0d28gYWRh
cHRlcnMsDQo+IGFuZCBib3RoIG5lZWQgcmVzZXQNCj4gICBzaW11bHRhbmVvdXNseQ0KPiAtIHNp
bmNlIHdvcmsgc3RydWN0IGlzIGluZGVwZW5kZW50IG9mIHRoZSBpbnRlcmZhY2UgKHNkaW9fZnVu
YyksIGl0IHdpbGwNCj4gYWxzbyBub3QgYmUgbm90aWZpZWQNCj4gICBpZiB0aGUgY2FyZCBpcyBy
ZW1vdmVkIHBoeXNpY2FsbHkNCg0KVGhhbmtzIGZvciBhbiBleHBsYW5hdGlvbi4gWW91IGFyZSBy
aWdodC4gT3VyIHBhdGNoIGRvZXNu4oCZdCBhZGRyZXNzIGFib3ZlIG1lbnRpb25lZCBwcm9ibGVt
cy4NCkFkYXB0ZXIgbGlzdCBhbmQgbXV0ZXggbG9naWMgaW4geW91ciBwYXRjaCB3b3VsZCByZXNv
bHZlIHRoZXNlIGlzc3Vlcy4gQ291bGQgeW91IHBsZWFzZSBwcmVwYXJlIGEgcGF0Y2ggb24gdG9w
IG9mIGxhdGVzdCBjb2RlPw0KDQpSZWdhcmRzLA0KQW1pdA0K
