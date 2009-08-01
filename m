Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:56107 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbZHAJmQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 05:42:16 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MXB6S-00045I-Nw
	for linux-wireless@vger.kernel.org; Sat, 01 Aug 2009 09:42:12 +0000
Received: from dslb-084-058-206-191.pools.arcor-ip.net ([84.58.206.191])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2009 09:42:12 +0000
Received: from acid-burn by dslb-084-058-206-191.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2009 09:42:12 +0000
To: linux-wireless@vger.kernel.org
From: Mladen Horvat <acid-burn@opendreambox.org>
Subject: Re: zd1211rw with MIPS architecture: mysterious behavior with zd1211b and AL2230/AL2230S RF Chip
Date: Sat, 1 Aug 2009 09:41:58 +0000 (UTC)
Message-ID: <loom.20090801T093912-439@post.gmane.org>
References: <loom.20090731T125828-710@post.gmane.org> <4A733FF1.7050301@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joerg Albert <jal2@...> writes:

> 
> On 07/31/2009 03:11 PM, Mladen Horvat wrote:
> 
> > the same stick runs flawless on a x86 pc with kernel 2.6.30.
> > as i said, also on the same machine with kernel 2.6.12 and the vendor driver
> > this stick works without problems.
> > 
> > perhaps someone has an idea ?
> 
> Just a wild guess, if your target runs MIPS in big endian: a missing endian
conversion in the zd1211rw driver?
> Wasn't USB little-endian based?

CONFIG_CPU_LITTLE_ENDIAN=y  , so this should not be the problem i think

> If the stick runs on the same MIPS target with 2.6.12 and vendor driver, it
shouldn't be a USB 1.1 vs. 2.0
> problem - I guess the stick is a high speed device, as the zd1211b supports
802.11g.

if i remember the vendor driver correctly it uses 11g if usb2.0 is used and
switches automatically to 11b mode for usb1.1

perhaps its some sort of timing issue ?

regards

Mladen

