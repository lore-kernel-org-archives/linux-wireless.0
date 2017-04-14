Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39743 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750747AbdDNEvP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 00:51:15 -0400
From: Xinming Hu <huxm@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Xinming Hu <huxinming820@gmail.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: RE: [EXT] Re: [PATCH v4 4/4] mwifiex: pcie: extract wifi part from
 combo firmware during function level reset
Date: Fri, 14 Apr 2017 04:51:10 +0000
Message-ID: <108c4017c75740e18343cfa365cc2bab@SC-EXCH02.marvell.com> (sfid-20170414_065145_069761_FFEB3059)
References: <1492066102-31251-1-git-send-email-huxinming820@gmail.com>
        <1492066102-31251-4-git-send-email-huxinming820@gmail.com>
 <87wpaobe8x.fsf@purkki.adurom.net>
In-Reply-To: <87wpaobe8x.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgS2FsbGUsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS2FsbGUg
VmFsbyBbbWFpbHRvOmt2YWxvQGNvZGVhdXJvcmEub3JnXQ0KPiBTZW50OiAyMDE3xOo01MIxM8jV
IDIxOjU5DQo+IFRvOiBYaW5taW5nIEh1DQo+IENjOiBMaW51eCBXaXJlbGVzczsgQnJpYW4gTm9y
cmlzOyBEbWl0cnkgVG9yb2tob3Y7IHJhamF0amFAZ29vZ2xlLmNvbTsNCj4gQW1pdGt1bWFyIEth
cndhcjsgQ2F0aHkgTHVvOyBYaW5taW5nIEh1OyBHYW5hcGF0aGkgQmhhdA0KPiBTdWJqZWN0OiBb
RVhUXSBSZTogW1BBVENIIHY0IDQvNF0gbXdpZmlleDogcGNpZTogZXh0cmFjdCB3aWZpIHBhcnQg
ZnJvbSBjb21ibw0KPiBmaXJtd2FyZSBkdXJpbmcgZnVuY3Rpb24gbGV2ZWwgcmVzZXQNCj4gDQo+
IEV4dGVybmFsIEVtYWlsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IFhpbm1pbmcgSHUgPGh1eGlu
bWluZzgyMEBnbWFpbC5jb20+IHdyaXRlczoNCj4gDQo+ID4gRnJvbTogWGlubWluZyBIdSA8aHV4
bUBtYXJ2ZWxsLmNvbT4NCj4gPg0KPiA+IEEgc2VwcmF0ZSB3aWZpLW9ubHkgZmlybXdhcmUgd2Fz
IGRvd25sb2FkIGR1cmluZyBwY2llIGZ1bmN0aW9uIGxldmVsIHJlc2V0Lg0KPiA+IEl0IGlzIGlu
IGZhY3QgdGhlIHRhaWwgcGFydCBvZiB3aWZpL2J0IGNvbWJvIGZpcm13YXJlLiBQZXIgQnJpYW4n
cyBhbmQNCj4gPiBEbWl0cnkncyBzdWdnZXN0aW9uLCB0aGlzIHBhdGNoIGV4dHJhY3QgdGhlIHdp
ZmkgcGFydCBmcm9tIGNvbWJvIGZpcm13YXJlLg0KPiA+DQo+ID4gQWZ0ZXIgdGhhdCwgd2UgY2Fu
IGRpc2NhcmQgdGhlIHJlZHVkYW50IGltYWdlIGluIGxpbnV4LWZpcm13YXJlIHJlcG8uDQo+IA0K
PiBJZiB5b3UgbWVhbiB3aXRoIGRpc2NhcmRpbmcgcmVtb3ZpbmcgdGhlIGFjdHVhbCBpbWFnZSBm
cm9tIGxpbnV4LWZpcm13YXJlLA0KPiB0aGVuIHlvdSBjYW5ub3QgZG8gdGhhdC4gVGhlIGltYWdl
IGlzIHN0aWxsIG5lZWRlZCBzbyB0aGF0IGxpbnV4LWZpcm13YXJlDQo+IHdvcmtzIHdpdGggb2xk
ZXIga2VybmVscy4NCj4gDQpZZXMsIHdlIHdpbGwga2VlcCBpdC4NCg0KVGhhbmtzLA0KU2ltb24N
Cj4gLS0NCj4gS2FsbGUgVmFsbw0K
