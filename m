Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab1CHOKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 09:10:19 -0500
Subject: Re: [RFC 2/9] mac80211: add WoW param to suspend/resume functions
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1299011804-13899-3-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
	 <1299011804-13899-3-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 15:10:17 +0100
Message-ID: <1299593417.4676.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-01 at 22:36 +0200, Eliad Peller wrote:
> Upon suspend/resume cfg80211 passes additional WoW param,
> which contains the enabled Wake-On-Wireless triggers.
> 
> Add this param to the related functions (ieee80211_suspend,
> ieee80211_resume, ieee80211_reconfig, ieee80211_stop_driver),
> and pass NULL when calling these functions by ourselves
> (e.g. on restart work)

Same comment/question here for passing to suspend and passing NULL --
but it's just pass-through from cfg80211.

johannes

