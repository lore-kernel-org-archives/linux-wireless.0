Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33673 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754638AbcIMR5o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 13:57:44 -0400
From: "Pedersen, Thomas" <twp@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Ben Greear <greearb@candelatech.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: cap 20MHz VHT bitrate at MCS 8
Date: Tue, 13 Sep 2016 17:57:41 +0000
Message-ID: <1473789454.27738.7.camel@qca.qualcomm.com> (sfid-20160913_195747_925883_F0365427)
References: <1473188417-13987-1-git-send-email-twp@qca.qualcomm.com>
         <2769a14e-964d-4ec2-9f04-ddd332434b78@candelatech.com>
         <38049c4f-da5b-a6ec-bcc4-c803197abcd7@qca.qualcomm.com>
         <1473662637.4201.2.camel@sipsolutions.net>
In-Reply-To: <1473662637.4201.2.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCAyMDE2LTA5LTEyIGF0IDA4OjQzICswMjAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBPbiBXZWQsIDIwMTYtMDktMDcgYXQgMTg6MjAgKzAwMDAsIFBlZGVyc2VuLCBUaG9tYXMgd3Jv
dGU6DQo+ID4gDQo+ID4gT24gMDkvMDYvMjAxNiAxMjowNyBQTSwgQmVuIEdyZWVhciB3cm90ZToN
Cj4gPiA+IA0KPiA+ID4gDQo+ID4gPiBPbiAwOS8wNi8yMDE2IDEyOjAwIFBNLCBUaG9tYXMgUGVk
ZXJzZW4gd3JvdGU6DQo+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gU29tZSBkcml2ZXJzIChh
dGgxMGspIHJlcG9ydCBNQ1MgOSBAIDIwTUh6LCB3aGljaA0KPiA+ID4gPiB0ZWNobmljYWxseSBp
c24ndCBhbGxvd2VkLiBUbyBnZXQgbW9yZSBtZWFuaW5nZnVsIHZhbHVlDQo+ID4gPiA+IHRoYW4g
MCBvdXQgb2YgdGhpcyBob3dldmVyLCBqdXN0IGNhcCB0aGUgYml0cmF0ZSBmb3IgMjBNSHoNCj4g
PiA+ID4gdG8gTUNTIDguDQo+ID4gPiANCj4gPiA+IElmIGl0IGlzIGFjdHVhbGx5IHJlcG9ydGlu
ZyBNQ1M5LCB3aHkgbGllIGFib3V0IGl0P8KgwqBSZXBvcnQgaXQgdXANCj4gPiA+IHRoZSBzdGFj
ayBhcyBhIHByb3BlciB2YWx1ZSBpbnN0ZWFkIG9mIGhpZGluZyB0aGUgaXNzdWU/DQo+ID4gDQo+
ID4gR29vZCBwb2ludCwgd2lsbCBzZW5kIGEgdjIgZXh0cmFwb2xhdGluZyB0aGUgdmFsdWUgdG8g
ODYuNU1iL3MuDQo+IA0KPiBUaGF0IG1ha2VzIG5vIHNlbnNlIGVpdGhlciwgSU1ITy4NCj4gDQo+
IEFyZSB5b3Ugc2F5aW5nIHRoYXQgYXRoMTBrIGFjdHVhbGx5IHNvbWVob3cgbWFuYWdlcyB0byB1
c2UgYW4gaW52YWxpZA0KPiBiaXRyYXRlIG92ZXIgdGhlIGFpcj8hDQo+IA0KPiBJdCBzZWVtcyBt
b3JlIGxpa2VseSB0aGF0IGl0J3MgYWN0dWFsbHkganVzdCBtaXNyZXBvcnRpbmcgd2hhdCBpdCdz
DQo+IGRvaW5nLCBhbmQgdGh1cyB0aGUgaXNzdWUgc2hvdWxkIGJlIGZpeGVkIGluIGF0aDEway4N
Cg0KWWVhaCBzbyBhcHBhcmVudGx5IHRoZSBvdmVyaGVhZCBpbnZvbHZlZCBpbiAyNTYtUUFNIDUv
NiAoTUNTIDkpIHJlc3VsdHMNCmluIGxvd2VyIGVmZmVjdGl2ZSBiaXRyYXRlIHRoYW4ganVzdCB1
c2luZyBNQ1MgOCAodW5sZXNzIHlvdSdyZSB1c2luZyAzDQpzcGF0aWFsIHN0cmVhbXMpLiBTb3Vu
ZHMgbGlrZSBhIHJhdGUgY29udHJvbCBvciByZXBvcnRpbmcgYnVnIHRoZW4uDQpQbGVhc2UgZHJv
cCB0aGlzLg0KDQpUaGFua3MsDQpUaG9tYXM=
