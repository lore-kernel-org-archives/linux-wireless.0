Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:46825 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab0EUUKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 16:10:19 -0400
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: linux-wireless@vger.kernel.org
Date: Fri, 21 May 2010 22:00:15 +0200
MIME-Version: 1.0
Subject: Re: How to scan APs with ATH5k?
CC: Bob Copeland <me@bobcopeland.com>
Message-ID: <4BF6E64F.15188.168D31@jafojtik.seznam.cz>
In-reply-to: <20100520224609.GA27842@hash.localnet>
References: <1274296671-13596-1-git-send-email-gwingerde@gmail.com>, <1274392411.7054.6.camel@mj>, <20100520224609.GA27842@hash.localnet>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Bob,

> > It looks like a bug.  Even if something is preventing scanning, the
> > error code should be -EBUSY (device busy).
> > 
> > The same is true for ath9k, but I cannot test ath5k at the moment.
> > mac80211 does a considerable effort to allow scanning while associated.
> 
> It's certainly something that used to work, but I haven't tried in
> a recent kernel.  So yes probably a bug.

BTW: I do not have recent kernel. I am using:
  linux-2.6.32.11 together with compat-wireless-2.6.34-rc4 


Anyway, wlan1 returns different error when associated:

#root@dvouramenna:~# iwlist wlan1 scanning
#wlan1     Failed to read scan data : Resource temporarily unavailable

regards
   J.Fojtik


> -- 
> Bob Copeland %% www.bobcopeland.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


