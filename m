Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2205 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZGEMbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 08:31:41 -0400
Date: Sun, 5 Jul 2009 08:31:05 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: kernel crashes, 2.6.30, rt2x00, ath5k, ieee80211_get_*_rate,
	automatic rate control
Message-ID: <20090705123105.GE2132@hash.localnet>
References: <20090621134954.GA31505@linux-m68k.org> <20090621180447.GA29469@hash.localnet> <20090623174616.GA3914@linux-m68k.org> <20090623202541.GA3635@hash.localnet> <20090625083636.GA6323@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090625083636.GA6323@linux-m68k.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 25, 2009 at 10:36:36AM +0200, Richard Zidlicky wrote:
> > The patch should already be on the way to stable, but I'll check on it.
> 
> thanks, you certainly have my vote that it should get into 2.6.30.*

Ok, it has been released in 2.6.30.1.

> On an unrelated note, the ath5k device is in a netbook with an wifi LED and
> Fn-F2 hotkey to toggle wlan.
> 
> The hotkey works, the LED not. What do I need to make the LED working on the 
> device?

Try latest wireless-testing or 2.6.31-rc1; there may already be a fix
for your hardware thanks to recently added rfkill support.

> Also, while the hotkey works how do query the current on/off status of it 
> in Linux?

There's the /dev/rfkill device (see http://git.sipsolutions.net/rfkill.git)
and I believe there are files under /sys/ as well which show the state but
I don't have the details handy (/sys/class/rfkill/xxx/state?).

Also I don't have any hardware with a kill switch/LED so YMMV :)

-- 
Bob Copeland %% www.bobcopeland.com

