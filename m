Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:50536 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaA2LAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 06:00:01 -0500
Message-ID: <1390993191.22155.5.camel@porter.coelho.fi> (sfid-20140129_120007_391032_E595345C)
Subject: Re: [PATCH 1/5] mac80211: batch CSA bss info notification
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Wed, 29 Jan 2014 12:59:51 +0200
In-Reply-To: <1390978581-13273-2-git-send-email-michal.kazior@tieto.com>
References: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
	 <1390978581-13273-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-29 at 07:56 +0100, Michal Kazior wrote:
> Instead of having
> ieee80211_bss_info_change_notify() scattered all
> over the place just call it once when finalizing
> CSA.
> 
> As a side effect this patch adds missing error
> checking for IBSS CSA beacon update.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---

Looks good to me:

Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>

