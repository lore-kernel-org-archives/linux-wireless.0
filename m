Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:41137 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaA2LC4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 06:02:56 -0500
Message-ID: <1390993370.22155.7.camel@porter.coelho.fi> (sfid-20140129_120259_857873_84F2EF0C)
Subject: Re: [PATCH 3/5] mac80211: move csa_active setting in STA CSA
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Wed, 29 Jan 2014 13:02:50 +0200
In-Reply-To: <1390978581-13273-4-git-send-email-michal.kazior@tieto.com>
References: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
	 <1390978581-13273-4-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-29 at 07:56 +0100, Michal Kazior wrote:
> The sdata->vif.csa_active could be left set after,
> e.g. channel context constraints check fail in STA
> mode leaving the interface in a strange state for
> a brief period of time until it is disconnected.
> This was harmless but ugly.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---

Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>

