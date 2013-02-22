Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3BVLIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 06:08:00 -0500
Message-ID: <1361531274.8146.2.camel@jlt4.sipsolutions.net> (sfid-20130222_120803_566442_BC36FC46)
Subject: Re: [PATCH] mac80211: Allow drivers to differentiate between ROC
 types
From: Johannes Berg <johannes@sipsolutions.net>
To: "W. Trevor King" <wking@tremily.us>
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>
Date: Fri, 22 Feb 2013 12:07:54 +0100
In-Reply-To: <20130222104612.GA25032@odin.tremily.us>
References: <1361525701-26172-1-git-send-email-johannes@sipsolutions.net>
	 <20130222104612.GA25032@odin.tremily.us>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-22 at 05:46 -0500, W. Trevor King wrote:
> On Fri, Feb 22, 2013 at 10:35:01AM +0100, Johannes Berg wrote:
> > + * operations comapred to other operations/flows.
> 
> I'm not qualified to review the patch code, but s/comapred/compared/.

Good catch, thanks, I'll fix it.

johannes

