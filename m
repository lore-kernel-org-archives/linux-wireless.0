Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50953 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3EFPMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 11:12:00 -0400
Message-ID: <1367853112.8434.6.camel@jlt4.sipsolutions.net> (sfid-20130506_171221_462059_3EEF5B8E)
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to
 1672c0e3
From: Johannes Berg <johannes@sipsolutions.net>
To: Jake Edge <jake@lwn.net>
Cc: linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Date: Mon, 06 May 2013 17:11:52 +0200
In-Reply-To: <20130505143803.7e46e4c6@chukar.edge2.net> (sfid-20130505_223826_138840_12AE724B)
References: <20130505143803.7e46e4c6@chukar.edge2.net>
	 (sfid-20130505_223826_138840_12AE724B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jake,

> commit 1672c0e31917f49d31d30d79067103432bc20cc7
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Tue Jan 29 15:02:27 2013 +0100
> 
>     mac80211: start auth/assoc timeout on frame status
> 
> but I can't (easily) revert that in 3.9 (maybe I can in -rc1 or
> something?  haven't tried that)
> 
> What more information is needed from me?  I may still mess around with
> trying to revert that patch just to nail it down for sure, but two
> separate bisection exercises ended up at the same place.

Thanks for the report. Is the AP on a passive channel by any chance (5
GHz, or channels 12/13)?

johannes

