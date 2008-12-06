Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45745 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbYLFOaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 09:30:12 -0500
Date: Sat, 6 Dec 2008 09:25:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Mats Johannesson <spamcan1@abrasax.se>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ath9k] 2.6.28-rc7-wl Kernel panic when "iwlist ath0 scan" as
	root
Message-ID: <20081206142517.GA26624@tuxdriver.com> (sfid-20081206_153023_594042_B25F7106)
References: <20081206113406.734f1d94@loke.fish.not> <20081206134542.05cd9664@loke.fish.not>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081206134542.05cd9664@loke.fish.not>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 06, 2008 at 01:45:42PM +0100, Mats Johannesson wrote:
> On Sat, 6 Dec 2008 11:34:06 +0100 Mats Johannesson wrote:
> > 
> > As the subject says, 2.6.28-rc7-wl git pulled Dec 6 exhibits a kernel
> > panic when doing "iwlist ath0 scan" as root under the ath9k driver.
> > Machine dead, panic LED blinking.
> > 
> > Scan as normal user is OK.
> 
> Ick! Panic as normal user as well when using the graphical "Wicd
> Manager" to Refresh (ie scan). Possibly it does its thing as root?
> 
> First panic was as root on a fresh kernel without any graphics driver
> (plain terminal). Second try was as a normal user in said plain
> terminal - was OK. Logged out and in as root to scan -> panic.
> 
> Installed graphics driver and ran as normal user under X. Wicd handles
> the wpa_supplicant etc. Scanning in an xterm as myself was OK. Later
> tried the Wicd Manager Refresh thing out of curiosity. Panic.

It would be helpful if you could capture the oops messages using a
serial console, netconsole, or even with a digital camera.  You may
also want to open a bug at bugzilla.kernel.org.

Thanks!

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
