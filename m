Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.brikks.com ([82.209.166.4]:7421 "EHLO smtp.bredband2.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754234AbYLGQaH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 11:30:07 -0500
Date: Sun, 7 Dec 2008 17:29:58 +0100
From: Mats Johannesson <spamcan1@abrasax.se>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ath9k] 2.6.28-rc7-wl Kernel panic when "iwlist ath0 scan" as
 root
Message-ID: <20081207172958.333e88e4@loke.fish.not> (sfid-20081207_173022_495784_CD329A0B)
In-Reply-To: <18747.60039.401701.441103@localhost.localdomain>
References: <20081206113406.734f1d94@loke.fish.not>
	<18746.37273.989918.333164@localhost.localdomain>
	<20081206180537.717d1791@loke.fish.not>
	<18746.48068.593834.660064@localhost.localdomain>
	<20081206202237.578b3783@loke.fish.not>
	<18747.15541.811292.500184@localhost.localdomain>
	<20081207150420.0f688772@loke.fish.not>
	<18747.60039.401701.441103@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 7 Dec 2008 20:53:51 +0530 Sujith wrote:
[...]
["This" snipped since I couldn't identify the line/lines doing it]

> This indicates that HT40 has been chosen.
> 
> The problem is this:
> 
> After association, ath9k has to set the appropriate channel width on
> doing a scan and mac80211 comes back to the home channel. Currently
> there is no such means to do that, and this why pinging fails.
> 
> We'll work on a solution, but until then you would have to choose
> HT20 in your AP.

All protocols are affected ping, whatever lies below telnet and http
through lynx was dead as well.

Ok, I'll try this version out a bit first with heavy p2p-transfers. If
it survives I might stick with it (2.6.28-rc6-wl died after awhile)
otherwise I'll go back to my all time favourite 2.6.27-rc5.

Wicd manager seems to keep a static list of APs in the environment I've
already scanned, so the issue is normally of no concern.

/Mats
