Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rwcrmhc12.comcast.net ([204.127.192.82]:60574 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965351AbXCFRUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2007 12:20:44 -0500
Date: Tue, 6 Mar 2007 09:15:41 -0800
From: Maxime Austruy <maxime@tralhalla.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: zd1211rw problems
Message-ID: <20070306171541.GA18622@tralhalla.org>
References: <1173142906.15891.71.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1173142906.15891.71.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, Mar 06, 2007 at 02:01:46AM +0100, Johannes Berg wrote:
> Hi,
> 
> I've been testing zd1211rw (not the mac80211 version) a bit on my
> powermac because I wanted to test AP mode for bcm43xx and use my zd1211
> device as a client... Thing is, I have a few problems with it already...
> 
> For one, I get lots of warnings like this (when running in monitor mode)
> 
> [ 3354.472204] drivers/net/wireless/zd1211rw/zd_chip.c:1467 ASSERT r >= 0 VIOLATED!
> [ 3354.472212] Call Trace:
> [ 3354.472222] [C000000001BCF6D0] [C00000000000F330] .show_stack+0x68/0x1b0 (unreliable)
> [ 3354.472247] [C000000001BCF770] [D000000000444F04] .zd_rx_qual_percent+0x164/0x200 [zd1211rw]
> [ 3354.472281] [C000000001BCF7F0] [D0000000004470CC] .do_rx+0x198/0x5c0 [zd1211rw]
> [ 3354.472307] [C000000001BCF8D0] [C000000000049978] .tasklet_action+0xd0/0x188
> [ 3354.472323] [C000000001BCF970] [C0000000000495C4] .__do_softirq+0xa8/0x164
 
Johannes,

fyi, this looks like: 
   http://bugzilla.kernel.org/show_bug.cgi?id=7752

Thanks,

Max
