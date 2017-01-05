Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:44004 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752317AbdAESTz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 13:19:55 -0500
Date: Thu, 05 Jan 2017 13:18:45 -0500 (EST)
Message-Id: <20170105.131845.1605952043383659916.davem@davemloft.net> (sfid-20170105_192140_649525_C9D20611)
To: stephen@networkplumber.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, oss-drivers@netronome.com,
        devel@linuxdriverproject.org, linux-ppp@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        dev@openvswitch.org, sthemmin@microsoft.com
Subject: Re: [PATCH net-next] net: make ndo_get_stats64 a void function
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170105173136.2817-1-sthemmin@microsoft.com>
References: <20170105173136.2817-1-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RnJvbTogU3RlcGhlbiBIZW1taW5nZXIgPHN0ZXBoZW5AbmV0d29ya3BsdW1iZXIub3JnPg0KRGF0
ZTogVGh1LCAgNSBKYW4gMjAxNyAwOTozMTozNiAtMDgwMA0KDQo+IFRoZSBuZXR3b3JrIGRldmlj
ZSBvcGVyYXRpb24gZm9yIHJlYWRpbmcgc3RhdGlzdGljcyBpcyBvbmx5IGNhbGxlZA0KPiBpbiBv
bmUgcGxhY2UsIGFuZCBpdCBpZ25vcmVzIHRoZSByZXR1cm4gdmFsdWUuIEhhdmluZyBhIHN0cnVj
dHVyZQ0KPiByZXR1cm4gdmFsdWUgaXMgcG90ZW50aWFsbHkgY29uZnVzaW5nIGJlY2F1c2Ugc29t
ZSBmdXR1cmUgZHJpdmVyIGNvdWxkDQo+IGluY29ycmVjdGx5IGFzc3VtZSB0aGF0IHRoZSByZXR1
cm4gdmFsdWUgd2FzIHVzZWQuDQo+IA0KPiBGaXggYWxsIGRyaXZlcnMgd2l0aCBuZG9fZ2V0X3N0
YXRzNjQgdG8gaGF2ZSBhIHZvaWQgZnVuY3Rpb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTdGVw
aGVuIEhlbW1pbmdlciA8c3RoZW1taW5AbWljcm9zb2Z0LmNvbT4NCg0KWW91IG1pc3NlZCBhdCBs
ZWFzdCBvbmUgbmV3IHdhcm5pbmcsIHBsZWFzZSBkbyBhIGZyZXNoIGFsbG1vZGNvbmZpZyBidWls
ZA0KYW5kIHdhdGNoIHRoZSBsb2dzLg0KDQpkcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9i
bngyLmM6IEluIGZ1bmN0aW9uIKFibngyX2dldF9zdGF0czY0ojoNCmRyaXZlcnMvbmV0L2V0aGVy
bmV0L2Jyb2FkY29tL2JueDIuYzo2ODMwOjEwOiB3YXJuaW5nOiChcmV0dXJuoiB3aXRoIGEgdmFs
dWUsIGluIGZ1bmN0aW9uIHJldHVybmluZyB2b2lkDQoNClRoYW5rcy4NCg==
