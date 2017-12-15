Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:59376 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753279AbdLOLUp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Dec 2017 06:20:45 -0500
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: "prameela.garnepudi@redpinesignals.com"
        <prameela.garnepudi@redpinesignals.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "amit.karwar@redpinesignals.com" <amit.karwar@redpinesignals.com>,
        "linux-snps-arc@lists.infradead.org"
        <linux-snps-arc@lists.infradead.org>
Subject: Re: rsi_91x: Low bandwidth: sends ~100 Kbits/sec, receives ~1.5
 Mbits/sec
Date: Fri, 15 Dec 2017 11:20:41 +0000
Message-ID: <1513336840.29404.21.camel@synopsys.com> (sfid-20171215_122051_198957_201CE935)
References: <1512490314.4977.143.camel@synopsys.com>
         <CAEhWJF=1GU9vOj5+DeJCOjbbh4zh_OMyv2HKH_1XT3XP2auFUg@mail.gmail.com>
         <1513277783.8750.27.camel@synopsys.com>
         <b4c2093d-cc2c-cdd3-52a5-73cefd2c189a@redpinesignals.com>
In-Reply-To: <b4c2093d-cc2c-cdd3-52a5-73cefd2c189a@redpinesignals.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgUHJhbWVlbGEsDQoNCk9uIEZyaSwgMjAxNy0xMi0xNSBhdCAxMToxMyArMDUzMCwgUHJhbWVl
bGEgUmFuaSBHYXJuZXB1ZGkgd3JvdGU6DQo+IEhpIEFsZXhleSwgDQo+IA0KPiBQbGVhc2UgdXNl
IHRoZSBhdHRhY2hlZCBwYXRjaCB0byBpbXByb3ZlIFRYIHRocm91Z2hwdXQuIFdlIHdpbGwgYmUg
DQo+IHN1Ym1pdHRpbmcgdGhpcyBwYXRjaCBhbG9uZyB3aXRoIGZldyBvdGhlcnMgc29vbi4gDQoN
CkNvdWxkIHlvdSBwbGVhc2Ugc3BlY2lmeSB3aGljaCBicmFuY2ggdGhpcyBwYXRjaCBpcyBiYXNl
ZCBvbj8NCkkgdHJpZWQgdG8gYXBwbHkgb24gNC4xNC41ICh3aGF0ZXZlciBpcyBsYXRlc3RzIGlu
ICJsaW51eC00LjE0LnkiKQ0KYnV0IGZpcnN0IDMgaHVua3MgZmFpbGVkIHRvIGFwcGx5Lg0KDQpN
YXliZSB0aGVyZSdyZSBvdGhlciBkZXBlbmRlbmNpZXM/DQoNCkFsc28gYSBjb3VwbGUgb2YgcXVl
c3Rpb25zIGFib3V0IHRoaXMgcGF0Y2guDQpFdmVuIHRob3VnaCBJJ20gbm90IGEgbmV0d29ya2lu
Zy9XaS1GaSBleHBlcnQgb2YgYW55IGtpbmQgYnV0IGp1c3QNCmxvb2tpbmcgYXQgeW91ciBjaGFu
Z2VzOg0KDQoxLiBJIGFzc3VtZSBmb3IgdXBzdHJlYW1pbmcgdGhhdCBwYXRjaCB3aWxsIGJlIHNw
bGl0IGluIDUgc2VwZXJhdGUgcGF0Y2hlcw0KICAgZWFjaCBhZGRyZXNzaW5nIGl0cyBvd24gaXRl
bSBpbnN0ZWFkIG9mIGRvaW5nIGFsbCBhdCBvbmNlLCByaWdodD8NCg0KMi4gVGhlIG9ubHkgb2J2
aW91cyBjaGFuZ2UgdGhhdCBtaWdodCBoZWxwIG1lIHdpdGggYmFuZHdpZHRoIGlzIGluY3JlYXNl
DQogICBvZiBhIG51bWJlciBvZiBhZ2dyZWdhdGVkIFR4IGZyYW1lcy4gQnV0IGJ1bXBpbmcgZnJv
bSA2IHRvIDggZG9lc24ndCBsb29rDQogICBhcyBhIHNpZ25pZmljYW50IGltcHJvdmVtZW50LiBI
b3cgdGhhdCBtaWdodCBicmluZyBUeCBiYW5kd2lkdGggYXQgbGVhc3QgdG8NCiAgIHdoYXQgSSBz
ZWUgb24gUngsIGkuZS4gbWFrZSB0aGluZ3MgMTAgdGltZXMgZmFzdGVyPw0KDQpBbHNvIHdoaWxl
IGF0IGl0IEknbSB3b25kZXJpbmcgd2h5IDVHSHogbW9kZSBkaWRuJ3Qgd29yayBmb3IgbWUgZXZl
biB0aG91Z2gNCiJpdyBsaXN0IiByZXBvcnRzIDUgR0h6IG1vZGUgc3VwcG9ydGVkOg0KLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0+OC0tLS0tLS0tLS0tLS0tLS0tLQ0KIyBpdyBsaXN0DQpXaXBoeSBw
aHkwDQouLi4NCiAgICAgIEZyZXF1ZW5jaWVzOg0KICAgICAgICAgICAqIDUxODAgTUh6IFszNl0g
KDIwLjAgZEJtKSAobm8gSVIpDQoNCiMgY2F0IC9ldGMvaG9zdGFwZC5jb25mDQppbnRlcmZhY2U9
d2xhbjANCmN0cmxfaW50ZXJmYWNlPS92YXIvcnVuL2hvc3RhcGQNCmN0cmxfaW50ZXJmYWNlX2dy
b3VwPTANCnNzaWQ9SFNESy1BUA0KaHdfbW9kZT1hDQpjaGFubmVsPTM2DQoNCiMgaG9zdGFwZCAt
QiAvZXRjL2hvc3RhcGQuY29uZg0KU3RhcnRpbmcgaG9zdGFwZDogQ29uZmlndXJhdGlvbiBmaWxl
OiAvZXRjL2hvc3RhcGQuY29uZg0KcnNpXzkxeDogPT09PiBJbnRlcmZhY2UgVVAgPD09PQ0KcmZr
aWxsOiBDYW5ub3Qgb3BlbiBSRktJTEwgY29udHJJUHY2OiBBRERSQ09ORihORVRERVZfVVApOiB3
bGFuMDogbGluayBpcyBub3QgcmVhZHkNCm9sIGRldmljZQ0Kd2xhbjA6IElFRUUgODAyLjExIENv
bmZpZ3VyZWQgY2hhbm5lbCAoMzYpIG5vdCBmb3VuZCBmcm9tIHRoZSBjaGFubmVsIGxpc3Qgb2Yg
Y3VycmVudCBtb2RlICgyKSBJRUVFIDgwMi4xMWENCndsYW4wOiBJRUVFIDgwMi4xMSBIYXJkd2Fy
ZSBkb2VzIG5vdCBzdXBwb3J0IGNvbmZpZ3VyZWQgY2hhbm5lbA0KQ291bGQgbm90IHNlbGVjdCBo
d19tb2RlIGFuZCBjaGFubmVsLiAoLTMpDQp3bGFuMDogaW50ZXJmYWNlIHN0YXRlIFVOSU5JVElB
TElaRUQtPkRJU0FCTEVEDQp3bGFuMDogQVAtRElTQUJMRUQgDQp3bGFuMDogVW5hYmxlIHRvIHNl
dHVwIGludGVyZmFjZS4NCndsYW4wOiBpbnRlcmZhY2Ugc3RhdGUgRElTQUJMRUQtPkRJU0FCTEVE
DQp3bGFuMDogQVAtRElTQUJMRUQgDQpob3N0YXBkX2ZyZWVfaGFwZF9kYXRhOiBJbnRlcmZhY2Ug
d2xhbjAgd2Fzbid0IHN0YXJ0ZWQNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tPjgtLS0tLS0tLS0t
LS0tLS0tLS0NCg0KSGFzIGl0IHNvbWV0aGluZyB0byBkbyB3aXRoIHlvdXIgYW5vdGhlciBmaXgg
aW4gdGhhdCBwYXRjaD8NCg0KLUFsZXhleQ==
