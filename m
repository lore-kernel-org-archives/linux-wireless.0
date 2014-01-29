Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:58269 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaA2LFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 06:05:42 -0500
Message-ID: <1390993539.22155.8.camel@porter.coelho.fi> (sfid-20140129_120545_038080_FFF44888)
Subject: Re: [PATCH 5/5] mac80211: add missing CSA locking
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Wed, 29 Jan 2014 13:05:39 +0200
In-Reply-To: <1390978581-13273-6-git-send-email-michal.kazior@tieto.com>
References: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
	 <1390978581-13273-6-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-29 at 07:56 +0100, Michal Kazior wrote:
> The patch adds a missing sdata lock and adds a few
> lockdeps for easier maintenance.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---

Looks okay at first glance, but Johannes is the lock master and should
review this. ;)

Otherwise, the series looks fine to me.

--
Luca.

