Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:49206 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaBGKDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 05:03:33 -0500
Message-ID: <1391767410.18534.11.camel@porter.coelho.fi> (sfid-20140207_110336_490119_BFF44F37)
Subject: Re: [PATCH] mac80211_hwsim: fix number of channels in interface
 combinations
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Fri, 07 Feb 2014 12:03:30 +0200
In-Reply-To: <1391766341-10566-1-git-send-email-johannes@sipsolutions.net>
References: <1391766341-10566-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-07 at 10:45 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's little point in setting the number of channels if the
> entire combination struct is overwritten again later - that
> was clearly intended the other way around, fix it.
> 
> Reported-by: Luciano Coelho <luciano.coelho@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Thanks!

Tested-by: Luciano Coelho <luciano.coelho@intel.com>

--
Luca.

