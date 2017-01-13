Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5938 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751768AbdAMOVU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 09:21:20 -0500
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/6] iwlwifi: mvm: don't restart HW if suspend fails
 with unified image
Date: Fri, 13 Jan 2017 14:21:16 +0000
Message-ID: <1484317274.5227.146.camel@intel.com> (sfid-20170113_152129_182068_C40402B7)
References: <20170113123919.30384-1-luca@coelho.fi>
         <20170113123919.30384-2-luca@coelho.fi> <87inpjhwu8.fsf@purkki.adurom.net>
In-Reply-To: <87inpjhwu8.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gRnJpLCAyMDE3LTAxLTEzIGF0IDE2OjEzICswMjAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiBM
dWNhIENvZWxobyA8bHVjYUBjb2VsaG8uZmk+IHdyaXRlczoNCj4gDQo+ID4gRnJvbTogTHVjYSBD
b2VsaG8gPGx1Y2lhbm8uY29lbGhvQGludGVsLmNvbT4NCj4gPiANCj4gPiBGb3IgdW5pZmllZCBp
bWFnZXMsIHdlIHNob3VsZG4ndCByZXN0YXJ0IHRoZSBIVyBpZiBzdXNwZW5kIGZhaWxzLiAgVGhl
DQo+ID4gb25seSByZWFzb24gZm9yIHJlc3RhcnRpbmcgdGhlIEhXIHdpdGggbm9uLXVuaWZpZWQg
aW1hZ2VzIGlzIHRvIGdvDQo+ID4gYmFjayB0byB0aGUgRDAgaW1hZ2UuDQo+ID4gDQo+ID4gRml4
ZXM6IGNvbW1pdCAyM2FlNjEyODJiODggKCJpd2x3aWZpOiBtdm06IERvIG5vdCBzd2l0Y2ggdG8g
RDMgaW1hZ2Ugb24gc3VzcGVuZCIpDQo+IA0KPiBzL2NvbW1pdCAvLyA6KQ0KDQpBcmdoLCBkaWQg
SSBkbyBpdCBhZ2Fpbj8gSSB3YXMgc3BlY2lmaWNhbGx5IHRyeWluZyB0byByZW1lbWJlciB0aGlz
LCBidXQNCkkgZ3Vlc3MgaXQgd2FzIG5vdCBlbm91Z2guLi4NCg0KLS0NCkx1Y2Eu
