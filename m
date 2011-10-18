Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:49157 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab1JRSaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 14:30:06 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>
Date: Tue, 18 Oct 2011 11:27:44 -0700
Subject: RE: [patch 3/4] mwifiex: prevent corruption instead of just warning
Message-ID: <477F20668A386D41ADCC57781B1F70430817F5976B@SC-VEXCH1.marvell.com> (sfid-20111018_203012_846767_EA011E25)
References: <20111018061514.GI27732@elgon.mountain>
	 <477F20668A386D41ADCC57781B1F70430817F59764@SC-VEXCH1.marvell.com>
	 (sfid-20111018_202134_304312_48DE1FDF)
 <1318962180.3958.30.camel@jlt3.sipsolutions.net>
In-Reply-To: <1318962180.3958.30.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNClRoYW5rcyBmb3IgeW91ciBjb21tZW50Lg0KDQo+IC0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvaGFubmVzIEJlcmcgW21haWx0bzpqb2hhbm5lc0Bz
aXBzb2x1dGlvbnMubmV0XQ0KPiBTZW50OiBUdWVzZGF5LCBPY3RvYmVyIDE4LCAyMDExIDExOjIz
IEFNDQo+IFRvOiBCaW5nIFpoYW8NCj4gQ2M6IERhbiBDYXJwZW50ZXI7IEpvaG4gVy4gTGludmls
bGU7IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsga2VybmVsLWphbml0b3JzQHZnZXIu
a2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSRTogW3BhdGNoIDMvNF0gbXdpZmlleDogcHJldmVudCBj
b3JydXB0aW9uIGluc3RlYWQgb2YganVzdCB3YXJuaW5nDQo+IA0KPiBPbiBUdWUsIDIwMTEtMTAt
MTggYXQgMTE6MTkgLTA3MDAsIEJpbmcgWmhhbyB3cm90ZToNCj4gDQo+ID4gPiBAQCAtMTIyOCw5
ICsxMjI4LDExIEBAIHN0YXRpYyBpbnQgbXdpZmlleF9wY2llX2V2ZW50X2NvbXBsZXRlKHN0cnVj
dCBtd2lmaWV4X2FkYXB0ZXIgKmFkYXB0ZXIsDQo+ID4gPiAgCWlmICghc2tiKQ0KPiA+ID4gIAkJ
cmV0dXJuIDA7DQo+ID4gPg0KPiA+ID4gLQlpZiAocmRwdHIgPj0gTVdJRklFWF9NQVhfRVZUX0JE
KQ0KPiA+ID4gKwlpZiAocmRwdHIgPj0gTVdJRklFWF9NQVhfRVZUX0JEKSB7DQo+ID4gPiAgCQlk
ZXZfZXJyKGFkYXB0ZXItPmRldiwgImV2ZW50X2NvbXBsZXRlOiBJbnZhbGlkIHJkcHRyIDB4JXhc
biIsDQo+ID4gPiAgCQkJCQlyZHB0cik7DQo+ID4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPg0K
PiA+IEluc3RlYWQgb2YgcmV0dXJuaW5nIGRpcmVjdGx5LCB3ZSBzaG91bGQgc2V0IHRoZSBlcnJv
ciBjb2RlIGFuZCBnbyB0aHJvdWdoIHRoZSBlcnJvciBoYW5kbGluZzoNCj4gPiAJCXJldCA9IC1F
SU5WQUw7DQo+ID4gCQlnb3RvIGRvbmU7DQo+IA0KPiBBcmUgeW91IHN1cmU/IFlvdSBkb24ndCBn
byB0byBlcnJvciBoYW5kbGluZyBhIGZldyBsaW5lcyBlYXJsaWVyLg0KDQpUaGUgZXJyb3IgaGFu
ZGxpbmcgd2lsbCBmcmVlIHRoZSBza2IuIElmIHNrYiBpcyBOVUxMIHRoZXJlIGlzIG5vIG5lZWQg
dG8gZnJlZS4NCg0KVGhhbmtzLA0KQmluZw0KDQo+IA0KPiBqb2hhbm5lcw0KDQo=
