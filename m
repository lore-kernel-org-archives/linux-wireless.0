Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:39181 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933380AbaCSOBm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:01:42 -0400
Message-ID: <1395237674.2854.10.camel@dubbel> (sfid-20140319_150146_739962_9FBE63E0)
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com,
	eliad@wizery.com
Date: Wed, 19 Mar 2014 16:01:14 +0200
In-Reply-To: <1394547394-3910-1-git-send-email-luciano.coelho@intel.com>
References: <1394547394-3910-1-git-send-email-luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v10 0/5] cfg80211/mac80211: move interface combinations
 check to mac80211
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-11 at 16:16 +0200, Luciano Coelho wrote:
> Hi,
> 
> The history is getting too big, so drop it... *sigh*
> 
> Adressed some comment by Eliad (thanks!)
> 
> In v10:
> 
>    * ignore software iftypes when checking used_iftypes;
>    * ignore NL80211_IFTYPE_UNSPECIFIED instead of WARNing in
>      cfg80211_dfs_required();
> 
> Luca.
> 
> Luciano Coelho (5):
>   cfg80211: refactor cfg80211_can_use_iftype_chan()
>   cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()
>   cfg80211/mac80211: move interface counting for combination check to
>     mac80211
>   cfg80211/mac80211: move combination check to mac80211 for ibss
>   cfg80211/mac80211: move more combination checks to mac80211

I have applied this series to my mac80211-next-csa.git [1] tree.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/luca/mac80211-next-csa.git

--
Luca.

