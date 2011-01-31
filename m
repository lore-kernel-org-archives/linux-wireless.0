Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20911 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab1AaS5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:57:41 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 10:57:21 -0800
Date: Tue, 1 Feb 2011 00:26:52 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: disable power save if an infra AP vif exists
Message-ID: <20110131185646.GA3942@vmraj-lnx.users.atheros.com>
References: <1296499518-3895-1-git-send-email-rmanoharan@atheros.com>
 <1296500018.3812.42.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1296500018.3812.42.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 01, 2011 at 12:23:38AM +0530, Johannes Berg wrote:
> On Tue, 2011-02-01 at 00:15 +0530, Rajkumar Manoharan wrote:
> 
> > +		if ((sdata->vif.type == NL80211_IFTYPE_AP) ||
> > +		    (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {
> 
> I still think you should drop the VLAN check?
Sorry. I missed it.

--
Rajkumar
