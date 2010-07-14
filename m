Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab0GNKBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 06:01:06 -0400
Subject: Re: commit 062bee448bd539580ef9f64efe50fdfe04eeb103 broke my
 iwlagn 5100
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Klink <flokli@flokli.de>
Cc: linux-wireless@vger.kernel.org,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1279100021.7275.24.camel@flokli-laptop>
References: <1279100021.7275.24.camel@flokli-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 12:00:55 +0200
Message-ID: <1279101655.3719.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[correct wey-yi's address, remove reinette]

On Wed, 2010-07-14 at 11:33 +0200, Florian Klink wrote:
> Hi,
> 
> I hope I'm writing to the right addresses, this is my first kernel bug
> report :-)
> 
> I regulary build linus' tree from git. One day, my wireless card was
> unable to connect to the access point. dmesg showed something like this:
> 
> [  122.290949] wlan0: direct probe to 00:15:0c:xx:xx:xx (try 1)
> [  122.490158] wlan0: direct probe to 00:15:0c:xx:xx:xx (try 2)
> [  122.690057] wlan0: direct probe to 00:15:0c:xx:xx:xx (try 3)
> [  122.890031] wlan0: direct probe to 00:15:0c:xx:xx:xx timed out
> 
> At first, I thought is was some link quality problem and tried it next
> to the access point, but it still didn't work.
> I booted another (older) kernel and with this one, the card was able to
> connect without any problems.
> 
> I bisected the problem and came to commit
> 062bee448bd539580ef9f64efe50fdfe04eeb103
> iwlwifi: set TX_CMD_FLAG_PROT_REQUIRE_MSK in tx_flag
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=062bee448bd539580ef9f64efe50fdfe04eeb103
> 
> My wireless card is a Intel Corporation Wireless WiFi Link 5100.
> 
> Will provide more info if needed.
> 
> Florian
> 
> PS: Please CC me, i'm not on linux-wireless.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


