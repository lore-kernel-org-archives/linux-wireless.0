Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:41903 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaA2LBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 06:01:49 -0500
Message-ID: <1390993306.22155.6.camel@porter.coelho.fi> (sfid-20140129_120152_777536_31F364A0)
Subject: Re: [PATCH 2/5] mac80211: fix possible memory leak on AP CSA failure
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Wed, 29 Jan 2014 13:01:46 +0200
In-Reply-To: <1390978581-13273-3-git-send-email-michal.kazior@tieto.com>
References: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
	 <1390978581-13273-3-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-29 at 07:56 +0100, Michal Kazior wrote:
> If CSA for AP interface failed and the interface
> was not stopped afterwards another CSA request
> would leak sdata->u.ap.next_beacon.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---

Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>


