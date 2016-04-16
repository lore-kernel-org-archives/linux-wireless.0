Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18718 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbcDPTxK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 15:53:10 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "bp@alien8.de" <bp@alien8.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linuxwifi <linuxwifi@intel.com>,
	"Dreyfuss, Haim" <haim.dreyfuss@intel.com>,
	"Coelho, Luciano" <luciano.coelho@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Sharon, Sara" <sara.sharon@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: WARNING: CPU: 1 PID: 2485 at
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1752
 iwl_trans_pcie_grab_nic_access+0x110/0x120 [iwlwifi]
Date: Sat, 16 Apr 2016 19:53:04 +0000
Message-ID: <1460836384.2998.3.camel@intel.com> (sfid-20160416_215335_604358_7C873C45)
References: <20160415020710.GA2700@cz.tnic>
	 <1460693762.2648.5.camel@intel.com> <20160416154348.GA2069@cz.tnic>
In-Reply-To: <20160416154348.GA2069@cz.tnic>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gU2F0LCAyMDE2LTA0LTE2IGF0IDE3OjQzICswMjAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIEZyaSwgQXByIDE1LCAyMDE2IGF0IDA0OjE2OjAyQU0gKzAwMDAsIEdydW1iYWNoLCBF
bW1hbnVlbCB3cm90ZToNCj4gPiBbMV0gDQo+ID4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9jZ2l0
L2xpbnV4L2tlcm5lbC9naXQvaXdsd2lmaS9iYWNrcG9ydC1pd2x3aQ0KPiA+IGZpLmdpdC8NCj4g
DQo+IEl0IGlzIHZlcnkgc3RyYW5nZSB0byBwdWxsIGZyb20gdGhpcyByZXBvLCBnaXQgZmV0Y2gg
aXMgZG9pbmcNCj4gc29tZXRoaW5nDQo+IGZvciBhIHdoaWxlIG5vdyB3aXRob3V0IGFueSBmb3J3
YXJkIHByb2dyZXNzLg0KDQpUaGlzIGlzIG5vdCBzdXJwcmlzaW5nIGF0IGFsbC4gVGhpcyB0cmVl
IGlzIG5vdCBhIGtlcm5lbCB0cmVlLCBidXQNCnJhdGhlciBhIGJhY2twb3J0IHRyZWUuIEl0IGRv
ZXNuJ3QgY29udGFpbiBhbnl0aGluZyBiZXNpZGVzIHRoZSBXaWZpDQpzdGFjayBhbmQgdGhlIGJh
Y2twb3J0IGNvZGUuIEl0IGhhcyBubyBjb21tb24gY29tbWl0IHdpdGggdGhlIExpbnV4DQprZXJu
ZWwuIEkgdW5kZXJzdGFuZCB0aGF0IHlvdSBmZXRjaGVkIHRoaXMgdHJlZSBmcm9tIGEga2VybmVs
IHRyZWUgYnV0DQp0aGF0J3Mgbm90IGEgZ29vZCBpZGVhLiBHaXQgd2lsbCB0cnkgdG8gZmluZCBh
IGNvbW1vbiBhbmNlc3RvciBidXQgdGhhdA0Kd2lsbCBmYWlsLi4uIGFmdGVyIGEgaHVnZSBudW1i
ZXIgb2YgdGVudGF0aXZlcy4gWW91J2QgYmV0dGVyIGNsb25lIGl0Lg0KDQo+IEluIGFueSBjYXNl
LCA0LjUgaXMgYmFkIHRvbywgdGVzdGluZyA0LjQgbm93Lg0KDQpIZXJlIHlvdSBnby4NCg0KPiBJ
ICdtIHRyYXZlbGxpbmcgY3VycmVudGx5DQo+IHNvIHRoZSB3aG9sZSBiaXNlY3Rpb24gZGVhbCB3
aWxsIHRha2UgYSB3aG9sZSBidXQgSSdsbCBnZXQgdG8gaXQNCj4gZXZlbnR1YWxseS4NCg0KSSds
bCBiZSBnbGFkIHRvIHNlZSBzb21ldGhpbmcgY29taW5nIG91dCBvZiB0aGlzLCBidXQgSSBjYW4n
dCBzYXkgSSBhbQ0KdmVyeSBvcHRpbWlzdGljLg0KDQo+IA0KPiBUaGFua3MgZm9yIHRha2luZyBh
IGxvb2suDQo+IA==
