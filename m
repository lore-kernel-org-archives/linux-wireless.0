Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:34317 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754290AbYA2Ukp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 15:40:45 -0500
Date: Tue, 29 Jan 2008 21:37:46 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "Lars Ericsson" <Lars_Ericsson@telia.com>
Cc: "'Larry Finger'" <larry.finger@lwfinger.net>,
	"'John W. Linville'" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFT] [PATCH] rc80211-pid: fix rate adjusting
Message-ID: <20080129213746.790b68d2@morte> (sfid-20080129_204053_566588_911873DD)
In-Reply-To: <00f201c862b3$be1f00b0$0b3ca8c0@gotws1589>
References: <479E928C.5000709@lwfinger.net>
	<00f201c862b3$be1f00b0$0b3ca8c0@gotws1589>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 29 Jan 2008 21:15:49 +0100
"Lars Ericsson" <Lars_Ericsson@telia.com> wrote:

> Hi,
> 
> My test system is broken. 
> 
> I was using a kernel build a couple of days ago while I was doing the
> initial test with the new rate control function.
> 
> Since I was getting deviant result, I decided to build a fresh kernel 
> before I continue my test. I also had added some debugging to see what 
> actually happens.
> 
> Unfortunately the rt2x00/rt61pci driver is broken in current git. I'm using
> http://www.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git, 
> and the 'everything' branch. 
> 
> I got plenty of :
> [ 2119.568376] WARNING: at net/mac80211/rx.c:2022 __ieee80211_rx()

Could you check which one is the condition which fails at rx.c:2022, i.e.
by inserting three separate WARN_ON(1) statements?


--
Ciao
Stefano
