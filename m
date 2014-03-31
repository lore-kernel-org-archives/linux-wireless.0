Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:45570 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752150AbaCaLmk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 07:42:40 -0400
Message-ID: <1396266153.6794.4.camel@dubbel> (sfid-20140331_134244_684789_C3DF1B0F)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Mon, 31 Mar 2014 14:42:33 +0300
In-Reply-To: <1396259841-6359-4-git-send-email-michal.kazior@tieto.com>
References: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
	 <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
	 <1396259841-6359-4-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v3 3/4] cfg80211: export interface stopping function
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-31 at 11:57 +0200, Michal Kazior wrote:
> This exports a new cfg80211_stop_iface() function.
> 
> This is intended for driver internal interface
> combination management and channel switching.
> 
> Due to locking issues (it re-enters driver) the
> call is asynchronous and uses cfg80211 event
> list/worker.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---

Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>

