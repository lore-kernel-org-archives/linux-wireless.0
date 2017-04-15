Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59621 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751511AbdDOIze (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 04:55:34 -0400
From: Xinming Hu <huxm@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: RE:  Re: Re: Re: [PATCH v3 4/4] mwifiex: pcie: extract wifi part from
 combo firmware during function level reset
Date: Sat, 15 Apr 2017 08:55:17 +0000
Message-ID: <1f0552b6af0a41aa864a5b716f85eaa4@SC-EXCH02.marvell.com> (sfid-20170415_105540_540269_95840692)
References: <1491815374-6555-1-git-send-email-huxinming820@gmail.com>
 <1491815374-6555-4-git-send-email-huxinming820@gmail.com>
 <20170411013724.GA135531@google.com>
 <45a8fcd4f0384fa7b622cf3a87b41ea8@SC-EXCH02.marvell.com>
 <20170413174954.GA66124@google.com>
 <111627ea9fbd477e83622e8df51f109b@SC-EXCH02.marvell.com>
 <20170414165534.GA102425@google.com>
In-Reply-To: <20170414165534.GA102425@google.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgQnJhaW4sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQnJpYW4g
Tm9ycmlzIFttYWlsdG86YnJpYW5ub3JyaXNAY2hyb21pdW0ub3JnXQ0KPiBTZW50OiAyMDE3xOo0
1MIxNcjVIDA6NTYNCj4gVG86IFhpbm1pbmcgSHUNCj4gQ2M6IExpbnV4IFdpcmVsZXNzOyBLYWxs
ZSBWYWxvOyBEbWl0cnkgVG9yb2tob3Y7IHJhamF0amFAZ29vZ2xlLmNvbTsNCj4gQW1pdGt1bWFy
IEthcndhcjsgQ2F0aHkgTHVvOyBHYW5hcGF0aGkgQmhhdA0KPiBTdWJqZWN0OiBbRVhUXSBSZTog
UmU6IFJlOiBbUEFUQ0ggdjMgNC80XSBtd2lmaWV4OiBwY2llOiBleHRyYWN0IHdpZmkgcGFydCBm
cm9tDQo+IGNvbWJvIGZpcm13YXJlIGR1cmluZyBmdW5jdGlvbiBsZXZlbCByZXNldA0KPiANCj4g
RXh0ZXJuYWwgRW1haWwNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gSGksDQo+IA0KPiBPbiBGcmks
IEFwciAxNCwgMjAxNyBhdCAwMzoyODoyOEFNICswMDAwLCBYaW5taW5nIEh1IHdyb3RlOg0KPiA+
IEFjY29yZGluZyB0byB0aGUgZmlybXdhcmUgZG93bmxvYWQgcHJvdG9jb2wsIGV2ZXJ5IENNRCBz
aG91bGQgbm90IGV4Y2VlZA0KPiBNV0lGSUVYX1VQTERfU0laRS4NCj4gPiB3ZSBjYW4gYWRkIGEg
c2FuaXR5IGNoZWNrICwgbGlrZSwNCj4gPiBpZiAoZGF0YV9sZW4gPiBNV0lGSUVYX1VQTERfU0la
RSAtIHNpemVvZihmd2RhdGEtPmhlYWRlcikpDQo+ID4gCSplcnJvcioNCj4gDQo+IEkgd2FzIHBy
aW1hcmlseSBpbnRlcmVzdGVkIGluIHByb3RlY3RpbmcgdGhlIGtlcm5lbCBpdHNlbGYuIE9uY2Ug
dGhlIGtlcm5lbCBzdGFydHMNCj4gcGFyc2luZyB0aGUgZmlybXdhcmUsIHdlIGhhdmUgdG8gbWFr
ZSBzdXJlIGEgYmFkIGZpcm13YXJlIGZpbGUgd29uJ3QgZW5kIHVwDQo+IHdpdGggdXMgbG9vcGlu
ZyBpbmZpbml0ZWx5LCByZWFkaW5nL3dyaXRpbmcgaW52YWxpZCBtZW1vcnksIG9yIG90aGVyd2lz
ZQ0KPiBleHBvc2luZyBzZWN1cml0eSBvciBzdGFiaWxpdHkgaXNzdWVzLiBJIHdhc24ndCBuZWNl
c3NhcmlseSBpbnRlcmVzdGVkIGluIHZhbGlkYXRpbmcNCj4gZXZlcnkgcmVxdWlyZW1lbnQgb2Yg
dGhlIGVuZC1wb2ludCBkZXZpY2UuIEZvciBleGFtcGxlLCB3ZSdyZSBub3QgYm90aGVyaW5nDQo+
IGNoZWNraW5nIHRoZSBDUkNzLiBJIGZpZ3VyZWQgdGhhdCB0aGlzIHdhcyBhbGwgdGhlIGpvYiBv
ZiB5b3VyIFdpZmkgY2FyZCdzIGJvb3QNCj4gUk9NLg0KPiANCj4gU28sIHdlICpjYW4qIGltcGxl
bWVudCBjaGVja3MgbGlrZSB0aGlzLCBidXQgSSdkIHJlYWxseSBob3BlIHdlIGRvbid0IG5lZWQg
dGhpcw0KPiBwYXJ0aWN1bGFyIG9uZSwgYmVjYXVzZSB5b3VyIGNhcmQgc2hvdWxkIGJlIHRha2lu
ZyBjYXJlIG9mIHRoYXQuDQo+IA0KDQpHb3QgaXQsIHdlIHdpbGwga2VlcCBpbiBtaW5kIHRvIGNo
ZWNrIHRoZSBwb3NzaWJsZSBvdmVyZmxvdyBpbiBmdXR1cmUsIGVpdGhlciB1c2luZyBnZW5lcmFs
DQpwcm90ZWN0IG9yIHVuZGVyIGxpbWl0IGJ5IG91ciBkZXZpY2UgcmVxdWlyZW1lbnQuDQoNCj4g
UGxlYXNlIGNvbnNpZGVyIHJldmlld2luZyBteSBsYXRlc3Qgc3VibWlzc2lvbi4NCj4gDQoNClN1
cmUuDQoNClRoYW5rcywNClNpbW9uDQo+IFJlZ2FyZHMsDQo+IEJyaWFuDQo=
