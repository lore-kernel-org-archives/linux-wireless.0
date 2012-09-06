Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab2IFKLD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 06:11:03 -0400
Message-ID: <1346926291.5469.6.camel@jlt4.sipsolutions.net> (sfid-20120906_121107_344276_B1AC9BBB)
Subject: Re: [RFC V2 2/2] cfg80211/nl80211: Enable drivers to implement mac
 address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 06 Sep 2012 12:11:31 +0200
In-Reply-To: <50487650.3050303@qca.qualcomm.com>
References: <1346824110-26382-1-git-send-email-vthiagar@qca.qualcomm.com>
	  <1346824110-26382-2-git-send-email-vthiagar@qca.qualcomm.com>
	 <1346852578.4364.13.camel@jlt4.sipsolutions.net>
	 <50487650.3050303@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-06 at 15:39 +0530, Vasanthakumar Thiagarajan wrote:

> > So about the race condition ... shouldn't the initial MAC list be given
> > in the start_ap() call, so that the AP can start up with a proper ACL
> > already in place, rather than starting up&  then modifying later?
> 
> Ok. So the ap will start with the initial mac list and the list
> can also be changed dynamically?. I'm fine with this.

Just throwing it out for consideration, it would seem safer to me I
guess. Not that MAC ACLs are really a safety feature anyway, but ...

johannes

