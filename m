Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from test.hauke-m.de ([5.39.93.123]:43190 "EHLO test.hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaHWNmW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 09:42:22 -0400
Message-ID: <53F89A3B.3000201@hauke-m.de> (sfid-20140823_154227_839281_67C09A4E)
Date: Sat, 23 Aug 2014 15:42:19 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] bcma: add PCI ID for spromless BCM43227
References: <1408789351-5803-1-git-send-email-hauke@hauke-m.de> <CACna6ry5Nw6Z5fugawwELzv=EPBB1jKGRFSa6GrETU5gGtCCaw@mail.gmail.com>
In-Reply-To: <CACna6ry5Nw6Z5fugawwELzv=EPBB1jKGRFSa6GrETU5gGtCCaw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/23/2014 03:39 PM, Rafał Miłecki wrote:
> On 23 August 2014 12:22, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> This adds the PCI ID a BCM43227 without a sprom.
> 
> Do you have bcma log from detecting this chip? Is this really BCM43227?
> 
Sorry it is a BCM43217

[    2.457832] bcma: bus1: Found chip with id 0xA8D1, rev 0x00 and
package 0x08
[    2.464899] bcma: bus1: Core 0 found: ChipCommon (manuf 0x4BF, id
0x800, rev 0x27, class 0x0)
[    2.473421] bcma: bus1: Core 1 found: IEEE 802.11 (manuf 0x4BF, id
0x812, rev 0x1E, class 0x0)
[    2.482046] bcma: bus1: Core 2 found: PCIe (manuf 0x4BF, id 0x820,
rev 0x14, class 0x0)
...
[    8.435380] b43-phy0: Broadcom 43217 WLAN found (core revision 30)
[    8.441623] bcma: bus1: Switched to core: 0x812
[    8.450226] b43-phy0: Found PHY: Analog 9, Type 4 (N), Revision 17
[    8.456393] b43-phy0: Found Radio: Manuf 0x17F, ID 0x2057, Revision
14, Version 1

Hauke
