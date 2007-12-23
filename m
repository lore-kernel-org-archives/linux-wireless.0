Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:53392 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753395AbXLWEPI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 23:15:08 -0500
Date: Sun, 23 Dec 2007 05:14:05 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: ssnt2@eng.cam.ac.uk
Cc: linux-wireless@vger.kernel.org
Subject: Re: B43 not working
Message-ID: <20071223051405.4f3ceedd@morte> (sfid-20071223_041513_799544_42699045)
In-Reply-To: <200712230408.37562.ssnt2@eng.cam.ac.uk>
References: <200712230117.35920.ssnt2@eng.cam.ac.uk>
	<20071223041739.1f9e82cb@morte>
	<200712230408.37562.ssnt2@eng.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 23 Dec 2007 04:08:37 +0000
Shawn Tan <ssnt2@eng.cam.ac.uk> wrote:

> Yup, that's what I did. I downloaded the compat-wireless package and compiled 
> it. However, it seems like there's a compatibility problem with the package 
> modules and the default Ubuntu ones.
> 
> When I try to load rc80211_simple, it loads the ubuntu one. The compat package 
> doesn't build a rc80211_simple. So, if I load the ubuntu rate controller, it 
> loads the ubuntu mac80211, which has similar symbol problems with the b43 
> module.

You shouldn't need to load the rc80211_simple module which came with
Ubuntu. I think that the compat package comes with a rate control algorithm
built into mac80211 itself, so please just try to unload the Ubuntu
mac80211 and load the compat one. For sure Luis (the compat maintainer) has
more clues on this, anyway.


--
Ciao
Stefano
