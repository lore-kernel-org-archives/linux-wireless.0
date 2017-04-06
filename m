Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39562 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753814AbdDFIJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 04:09:06 -0400
From: Xinming Hu <huxm@marvell.com>
To: Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>
CC: Xinming Hu <huxinming820@gmail.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "Rajat Jain" <rajatja@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>
Subject: RE: [EXT] Re: [PATCH 3/3] mwifiex: pcie: avoid hardcode wifi-only
 firmware name
Date: Thu, 6 Apr 2017 08:08:58 +0000
Message-ID: <c245cfd3b00b4d89840bf7e08113af59@SC-EXCH02.marvell.com> (sfid-20170406_100912_692947_0AB697E5)
References: <1490865547-10208-1-git-send-email-huxinming820@gmail.com>
 <1490865547-10208-3-git-send-email-huxinming820@gmail.com>
 <CAE_wzQ-6irwa5_HeQuRk3kOcLBrYR9N9XNFPg_xx7tmWcHdgGA@mail.gmail.com>
 <20170403184857.GC116262@google.com>
In-Reply-To: <20170403184857.GC116262@google.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgQnJhaW4sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQnJpYW4g
Tm9ycmlzIFttYWlsdG86YnJpYW5ub3JyaXNAY2hyb21pdW0ub3JnXQ0KPiBTZW50OiAyMDE3xOo0
1MI0yNUgMjo0OQ0KPiBUbzogRG1pdHJ5IFRvcm9raG92DQo+IENjOiBYaW5taW5nIEh1OyBMaW51
eCBXaXJlbGVzczsgS2FsbGUgVmFsbzsgUmFqYXQgSmFpbjsgQW1pdGt1bWFyIEthcndhcjsgQ2F0
aHkNCj4gTHVvOyBYaW5taW5nIEh1DQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbUEFUQ0ggMy8zXSBt
d2lmaWV4OiBwY2llOiBhdm9pZCBoYXJkY29kZSB3aWZpLW9ubHkNCj4gZmlybXdhcmUgbmFtZQ0K
PiANCj4gRXh0ZXJuYWwgRW1haWwNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gT24gRnJpLCBNYXIg
MzEsIDIwMTcgYXQgMDM6NTA6MjdQTSAtMDcwMCwgRG1pdHJ5IFRvcm9raG92IHdyb3RlOg0KPiA+
IFRoYXQgc2FpZCwgSSBjb25zaWRlciB0aGUgd2hvbGUgd2lmaS1vbmx5IGZpcm13YXJlIGJ1c2lu
ZXNzIGlzIHF1aXRlDQo+ID4gZnJhZ2lsZS4gQ2FuIHdlIGhhdmUgdW5pZmllZCBmaXJtd2FyZSBh
bmQgaGF2ZSBkcml2ZXIgZmlndXJlIG91dCB3aGF0DQo+ID4gcGFydCBzaG91ZGwgYmUgW3JlXWxv
YWRlZD8NCj4gDQo+ICsxLiBJIHRoaW5rIHdlIHNob3VsZCByZWFsbHkgZ2l2ZSBhIHN0YWIgYXQg
dGhpcyBmaXJzdCwgYW5kICp0aGVuKiBzZWUNCj4gaG93IHdlIHdhbnQgdG8gcGF0Y2ggdXAgdGhl
IGZsYWdnaW5nIG9mIHN1cHBvcnQgb24gYSBwZXItY2hpcHNldCBiYXNpcy4NCj4gQXMtaXMsIHlv
dSdyZSB3YXN0aW5nIGZpbGVzeXN0ZW0gc3BhY2Ugb24gYSBkdXBsaWNhdGUgZmlybXdhcmUgYmxv
YiwgdGhhdCB3ZQ0KPiBoYXZlIHRvIG1ha2Ugc3VyZSBnZXRzIHVwZGF0ZWQgaW4gc3luYyB3aXRo
IHRoZSBjb21iaW5lZCBmaXJtd2FyZSBldmVyeQ0KPiB0aW1lIHRoZXJlJ3MgYW4gdXBkYXRlLg0K
PiANCj4gUHJvb2Ygb2YgdGhlIGR1cGxpY2F0ZSBibG9iIC0tIHRoZSBsYXR0ZXIgcG9ydGlvbiBv
ZiB0aGUgY29tYmluZWQgRlcgaXMgaWRlbnRpY2FsDQo+IHRvIHRoZSBXTEFOLW9ubHk6DQo+IA0K
PiAgICQgY21wIG1ydmwvcGNpZXt1c2I4OTk3X2NvbWJvLDg5OTdfd2xhbn1fdjQuYmluICQoKDB4
MjkxOWMpKTsgZWNobyAkPw0KPiAgIDANCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3LCB3ZSBoYXZl
IGEgbmV3IHNvbHV0aW9uIGZvciBleHRyYWN0aW5nIHdpZmktb25seSBwYXJ0IGZyb20gY29tYm8g
ZmlybXdhcmUsIHdpbGwgc2VuZCBpdCBpbiB2Mi4NCg0KVGhhbmtzDQpTaW1vbg0KPiANCj4gQnJp
YW4NCg==
