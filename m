Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:37460 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab1B0PM7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 10:12:59 -0500
Subject: Re: searching for wireless card
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: Markus Feldmann <feldmann_markus@gmx.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <ikc2an$1un$1@dough.gmane.org>
References: <ikc2an$1un$1@dough.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Feb 2011 16:12:50 +0100
Message-ID: <1298819570.2933.2.camel@gnutoo-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-02-27 at 00:28 +0100, Markus Feldmann wrote:
> Hi All,
> 
> i am searching for a wireless card with the following attributes:
> +linux compatible
> +b/g/n or a/b/g/n network compatible
> +opensource driver
> +productive and stable to use under Linux
> +not to old chip
> +atheros chip preferred
> +PCI
> +usable in Master Mode(Access Point)
I'm using an ath9k in AP mode, and it seem to work well for me.
My card is a PCI one.
altough no a
only b/g/n:
wlan0     IEEE 802.11bgn  Mode:Master  Frequency:2.442 GHz  Tx-Power=20
dBm   
And I use only g, I'm not sure if n works yet.
> 
> I still found some cards which are nice, but maybe too old:
> Linksys WMP300N (only b/g)
> D-Link DWA-547 (b/g/n, PCI ?)
> 
> Some further Questions to help me decide:
> Is the Atheros Chip AR5xxx older than the AR9xxx?
> What is the advantage of 3 antennas instead of only 2 or 1?
ath9k is more recent and its driver seem more actively developed than
ath5k.

Denis.


