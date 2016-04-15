Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:19828 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbcDOEQI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 00:16:08 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"bp@alien8.de" <bp@alien8.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linuxwifi <linuxwifi@intel.com>,
	"Dreyfuss, Haim" <haim.dreyfuss@intel.com>,
	"Coelho, Luciano" <luciano.coelho@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Sharon, Sara" <sara.sharon@intel.com>
Subject: Re: WARNING: CPU: 1 PID: 2485 at
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1752
 iwl_trans_pcie_grab_nic_access+0x110/0x120 [iwlwifi]
Date: Fri, 15 Apr 2016 04:16:02 +0000
Message-ID: <1460693762.2648.5.camel@intel.com> (sfid-20160415_061629_619425_3ECA7BC1)
References: <20160415020710.GA2700@cz.tnic>
In-Reply-To: <20160415020710.GA2700@cz.tnic>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gRnJpLCAyMDE2LTA0LTE1IGF0IDAyOjA3ICswMDAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IEhpLA0KPiANCj4gc28gSSdtIHNlZWluZyB0aGlzIHdoZW4gd2xhbjAgdHJpZXMgdG8gYXNz
b2NpYXRlLiBPbiA0LjYtcmMyICsgdGlwLg0KPiBBZnRlciB0aGF0LCB3aWZpIGlzIGRlYWQgaW4g
dGhlIHdhdGVyLiBBbnlvbmUgaGF2ZSBhIGNsdWU/DQo+IA0KPiBBbmQgNC41IHNlZW1zIGZpbmUs
IEknbSB0eXBpbmcgZnJvbSBpdCBhcyB3ZSBzcGVhay4NCj4gLi4uDQoNCjxzbmlwPg0KDQoNCj4g
WyAgNjYxLjE0MjY1N10gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tDQo+IFsg
IDY2MS4xNDI4MTZdIFdBUk5JTkc6IENQVTogMSBQSUQ6IDI0ODUgYXQNCj4gZHJpdmVycy9uZXQv
d2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9wY2llL3RyYW5zLmM6MTc1Mg0KPiBpd2xfdHJhbnNfcGNp
ZV9ncmFiX25pY19hY2Nlc3MrMHgxMTAvMHgxMjAgW2l3bHdpZmldDQo+IFsgIDY2MS4xNDMyMzFd
IFRpbWVvdXQgd2FpdGluZyBmb3IgaGFyZHdhcmUgYWNjZXNzIChDU1JfR1BfQ05UUkwNCj4gMHhm
ZmZmZmZmZikNCj4gDQoNClRoaXMgbWVhbnMgdGhhdCB3ZSBoYXZlIGFuIGVsZWN0cmljYWwgaXNz
dWUgdGhhdCBwcmV2ZW50cyB1cyBmcm9tDQphY2Nlc3NpbmcgdGhlIGRldmljZSBvdmVyIHRoZSBQ
Q0kgYnVzLiBCQVIgaGFzIGJlZW4gZ2FyYmFnZWQgb3IgYWxpa2UuDQpFdmVyeSB0aW1lIEkgdHJp
ZWQgdG8gZGVidWcgdGhhdCBmcm9tIHRoZSBkcml2ZXIgc2lkZSBpdCBoYXMgLi4uDQpmYWlsZWQu
IEJlY2F1c2UgdGhlICJnb29kIiBpbiB0aGUgZW5kIGRpZCBleGhpYml0IHRoZSBwcm9ibGVtLiBT
bywNCnVubGVzcyB5b3UgYXJlIHJlYWR5IHRvIGVtYmFyayBmb3IgYSBiaXNlY3Rpb24gam91cm5l
eSAoYW5kIGhvcGUgdGhhdA0KdGhpcyB0aW1lIHdoZW4geW91IHR5cGUgJ2dpdCBiaXNlY3QgZ29v
ZCcgaXQgaXMgcmVhbGx5ICdnb29kJyksIEkgY2FuJ3QNCmRvIG11Y2guDQpXaGF0IEkgY2FuIHN1
Z2dlc3QgaXMgdG8gaW5zdGFsbCBvdXIgbGF0ZXN0IGJhY2twb3J0IGJhc2VkIHRyZWUgb24gNC41
Lg0KVGhpcyB3aWxsIGFsbG93IHlvdSB0byBoYXZlIGFuIGVhc2lseSBiaXNlY3RhYmxlIHRyZWUu
IEJ1dCBpdCBtaWdodA0KdmVyeSB3ZWxsIGJlIHRoYXQgNC41ICsgbGF0ZXN0IGRyaXZlciAoZXF1
aXZhbGVudCB0byA0LjYgYXMgZmFyIGFzDQppd2x3aWZpIGlzIGNvbmNlcm5lZCkgd2lsbCBiZSBm
aW5lLg0KVGhlIGJhY2twb3J0IHRyZWUgaXMgaGVyZSBbMV0uIFVuZm9ydHVuYXRlbHksIHRoYXQn
cyB0aGUgb25seSB0aGluZyBJDQpjYW4gc3VnZ2VzdCBmb3Igbm93Lg0KDQpbMV0gaHR0cHM6Ly9n
aXQua2VybmVsLm9yZy9jZ2l0L2xpbnV4L2tlcm5lbC9naXQvaXdsd2lmaS9iYWNrcG9ydC1pd2x3
aQ0KZmkuZ2l0Lw0KPiAtLSANCj4gUmVnYXJkcy9HcnVzcywNCj4gICAgIEJvcmlzLg0KPiANCj4g
RUNPIHRpcCAjMTAxOiBUcmltIHlvdXIgbWFpbHMgd2hlbiB5b3UgcmVwbHkuIFNyc2x5Lg==
