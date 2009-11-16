Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:58457 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbZKPXne (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 18:43:34 -0500
Message-ID: <4B01E39B.6090705@openwrt.org>
Date: Tue, 17 Nov 2009 00:43:23 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adam Wozniak <awozniak@irobot.com>
CC: Derek Smithies <derek@indranet.co.nz>,
	Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Adhoc networking, was Re: compat-wireless and minstrel
References: <4AF0D54D.4090303@irobot.com>  <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>  <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>  <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>  <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>  <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com> <1258392453.32159.28.camel@johannes.local> <4B0192A6.9050808@irobot.com> <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz> <4B01D4A5.7060204@irobot.com> <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz> <4B01E298.3030602@irobot.com>
In-Reply-To: <4B01E298.3030602@irobot.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adam Wozniak wrote:
> It seems like the code I pointed out earlier in rx.c is certainly wrong 
> then; bitrates used in absence of other information should not be 
> guessed based on the received rate, but should come instead from the 
> BSSID. Correct?
> 
> Although, once you start these silly examples, it seems to me like the 
> best thing to do is just assume the receiver can handle anything and let 
> minstrel sort out what works and what doesn't. This has obvious problems 
> for PID and similar rate algorithms.
In mesh networks here in Berlin and elsewhere, some people are running
with beacons disabled ('ahdemo' mode), so it would be nice if mac80211
could deal with this as well, by testing rates in absence of beacon
information.

- Felix
