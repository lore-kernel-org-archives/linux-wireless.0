Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47884 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbFDPun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 11:50:43 -0400
Message-ID: <557073D2.4080704@candelatech.com> (sfid-20150604_175047_209498_25CC70D9)
Date: Thu, 04 Jun 2015 08:50:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: David Lin <dlin@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>,
	Chor Teck Law <ctlaw@marvell.com>
Subject: Re: [PATCH] mwlwifi: Initial submission of wireless driver to mainline
References: <141c66f2950e4832a2bd99064db75970@SC-EXCH02.marvell.com>
In-Reply-To: <141c66f2950e4832a2bd99064db75970@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/03/2015 09:55 PM, David Lin wrote:
> Hi all,
> 
> 	Herewith, I am submitting the Linux driver for WRT1900AC. The work
> was initially developed as part of openwrt effort and maintained on
> https://github.com/kaloz/mwlwifi, thanks to the host where it is
> nurtured.
> 
> 	Recently, I have also patched it to pass checkpatch.pl so that it
> can be qualified for mainline.
> 
> 	This is still work in progress, with 8864 chipset more mature and
> tested, while 8897 for the similar use case is added recently. We
> will continue to maintain and enhance it.
> 
> We hope the community will welcome this initial submission!

Do you have any notes on what features this driver/NIC provides?

Does it require firmware, and if so, is source available?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

