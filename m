Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58370 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750812AbeAPJbV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 04:31:21 -0500
From: Xinming Hu <huxm@marvell.com>
To: Linux Firmware <linux-firmware@kernel.org>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Bob Tan <tanbo@marvell.com>,
        "Xu (Shanghai) Wang" <xwang4@marvell.com>
Subject: RE: pull-request mwifiex-firmware 2018-01-16
Date: Tue, 16 Jan 2018 09:31:18 +0000
Message-ID: <0c55d63be096467897b31ba080df0106@SC-EXCH02.marvell.com> (sfid-20180116_103125_840719_B2CE89DE)
References: <1516092471-9041-1-git-send-email-huxm@marvell.com>
In-Reply-To: <1516092471-9041-1-git-send-email-huxm@marvell.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGksDQoNClBsZWFzZSBpZ25vcmUgdGhpcyByZXF1ZXN0LCB0aGVyZSB3b3VsZCBiZSBhIGVuaGFu
Y2VkIHZlcnNpb24gZm9yIHRoaXMuDQoNClRoYW5rcw0KU2ltb24NCj4gLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgtd2lyZWxlc3Mtb3duZXJAdmdlci5rZXJuZWwub3Jn
DQo+IFttYWlsdG86bGludXgtd2lyZWxlc3Mtb3duZXJAdmdlci5rZXJuZWwub3JnXSBPbiBCZWhh
bGYgT2YgWGlubWluZyBIdQ0KPiBTZW50OiAyMDE4xOox1MIxNsjVIDE2OjQ4DQo+IFRvOiBMaW51
eCBGaXJtd2FyZSA8bGludXgtZmlybXdhcmVAa2VybmVsLm9yZz4NCj4gQ2M6IExpbnV4IFdpcmVs
ZXNzIDxsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc+OyBaaGl5dWFuIFlhbmcNCj4gPHlh
bmd6eUBtYXJ2ZWxsLmNvbT47IFRpbSBTb25nIDxzb25ndGFvQG1hcnZlbGwuY29tPjsgQ2F0aHkg
THVvDQo+IDxjbHVvQG1hcnZlbGwuY29tPjsgSmFtZXMgQ2FvIDxqY2FvQG1hcnZlbGwuY29tPjsg
R2FuYXBhdGhpIEJoYXQNCj4gPGdiaGF0QG1hcnZlbGwuY29tPjsgQm9iIFRhbiA8dGFuYm9AbWFy
dmVsbC5jb20+OyBYdSAoU2hhbmdoYWkpIFdhbmcNCj4gPHh3YW5nNEBtYXJ2ZWxsLmNvbT4NCj4g
U3ViamVjdDogcHVsbC1yZXF1ZXN0IG13aWZpZXgtZmlybXdhcmUgMjAxOC0wMS0xNg0KPiANCj4g
VGhlIGZvbGxvd2luZyBjaGFuZ2VzIHNpbmNlIGNvbW1pdA0KPiBkYjNlMTg1NWVhNDZiYzFhMjJi
OGJiZWNiNDAwYzI5MDljNTUxY2Y1Og0KPiANCj4gICBsaW51eC1maXJtd2FyZTogdXBkYXRlIE1h
cnZlbGwgUENJZS1VU0I4OTk3IGZpcm13YXJlIGltYWdlICgyMDE3LTEwLTMxDQo+IDIwOjQ5OjUz
ICswNTMwKQ0KPiANCj4gYXJlIGF2YWlsYWJsZSBpbiB0aGUgZ2l0IHJlcG9zaXRvcnkgYXQ6DQo+
IA0KPiAgIGdpdDovL2dpdC5tYXJ2ZWxsLmNvbS9td2lmaWV4LWZpcm13YXJlLmdpdA0KPiANCj4g
Zm9yIHlvdSB0byBmZXRjaCBjaGFuZ2VzIHVwIHRvIDA3ZDdhN2U1MTAzNGZjYzFjMmE3MmM1ZWVi
MTU2ZjFlOGFmZDMwMzg6DQo+IA0KPiAgIGxpbnV4LWZpcm13YXJlOiB1cGRhdGUgTWFydmVsbCBQ
Q0llLVVTQjg4OTctQTIgZmlybXdhcmUgaW1hZ2UNCj4gKDIwMTgtMDEtMTYgMTU6MDQ6MTEgKzA4
MDApDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tDQo+IFhpbm1pbmcgSHUgKDEpOg0KPiAgICAgICBsaW51eC1maXJt
d2FyZTogdXBkYXRlIE1hcnZlbGwgUENJZS1VU0I4ODk3LUEyIGZpcm13YXJlIGltYWdlDQo+IA0K
PiAgV0hFTkNFICAgICAgICAgICAgICAgICAgIHwgICAyICstDQo+ICBtcnZsL3BjaWU4ODk3X3Vh
cHN0YS5iaW4gfCBCaW4gODM2NTQwIC0+IDg0MzgyOCBieXRlcw0KPiAgMiBmaWxlcyBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0K
