Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38350 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbbGGJu1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 05:50:27 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chor Teck Law" <ctlaw@marvell.com>,
	"Pete Hsieh" <peteh@marvell.com>
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
 <CAOiHx=ncv=N33-CC-F0=_dovJ=PGsi3MBB3SEMg51fWcyuMmPg@mail.gmail.com>
 <e90aaab05cfd43fe9c05f738d4fc528a@SC-EXCH02.marvell.com>
 <CAOiHx=nnzfURJk6qeoyaV_qX0HPdtKSvZNmSNxKxypURMpNbkA@mail.gmail.com>
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
To: "David Lin" <dlin@marvell.com>, "Jonas Gorski" <jogo@openwrt.org>
Date: Tue, 07 Jul 2015 11:50:20 +0200
MIME-Version: 1.0
From: "Imre Kaloz" <kaloz@openwrt.org>
Message-ID: <op.x1edl6b82s3iss@ecaz> (sfid-20150707_115040_074372_F16710D7)
In-Reply-To: <CAOiHx=nnzfURJk6qeoyaV_qX0HPdtKSvZNmSNxKxypURMpNbkA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 07 Jul 2015 11:38:32 +0200, Jonas Gorski <jogo@openwrt.org> wrote:

<snip>

>>> I think it would be good to have some more precise description here
>>> (something like "Marvell 88W8864/8897 PCIe driver with AP support").
>>>
>>
>> Will change the title from "Marvell Wireless Wi-Fi driver (mwlwifi)" to  
>> "Marvell 88W8864/88W8897 PCIe driver with AP support".
>
> As Imre pointed out, mwifiex also supports AP mode, so this is not a
> good description.

On the short run, changing the description of the drivers could work, but  
I would suggest dropping (at least) 8897 support from mwifiex in favor of  
mwlwifi. If supporting the 8766 isn't complicated, I would drop PCIe  
support completely from there.

David, Chor Teck, could you shed some light on the future driver strategy?  
Does Marvell have any plans to add support for new chips to mwifiex, or do  
you plan to add usb support to mwlwifi later?


Cheers,

Imre
