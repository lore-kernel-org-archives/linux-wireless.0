Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:56295 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab3EFTQK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 15:16:10 -0400
Message-ID: <5188017D.10201@openwrt.org> (sfid-20130506_211614_709960_78E16532)
Date: Mon, 06 May 2013 21:16:13 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Jakub Kicinski <kubakici@wp.pl>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [RFC 12/14] rt2x00: rt61pci: implement queue_init
 callback
References: <1367497829-7672-1-git-send-email-juhosg@openwrt.org> <1367497829-7672-13-git-send-email-juhosg@openwrt.org> <20130506180624.07b47b86@north>
In-Reply-To: <20130506180624.07b47b86@north>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Thu,  2 May 2013 14:30:27 +0200, Gabor Juhos wrote:
>> The generic rt2x00 code has been changed to allow the
>> drivers toimplement dynamic data_queue initialization.
>>
>> Remove the static data queue descriptor structures
>> and implement the queue_init callback instead.
>>
>> Compile tested only.
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> 
> Seems to work on rt61pci as well ;)

Thanks for testing!

> Feel free to remove "Compile tested only." and/or add:
> 
> Tested-by: Jakub Kicinski <kubakici@wp.pl>

I will add your Tested-by tag when I will send the series as formal patches.

-Gabor
