Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:45538 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752504AbaCaLGc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 07:06:32 -0400
Message-ID: <1396263984.4478.13.camel@dubbel> (sfid-20140331_130639_627721_ACF57392)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Mon, 31 Mar 2014 14:06:24 +0300
In-Reply-To: <1396259841-6359-2-git-send-email-michal.kazior@tieto.com>
References: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
	 <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
	 <1396259841-6359-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v3 1/4] mac80211: fix CSA tx queue locking
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-31 at 11:57 +0200, Michal Kazior wrote:
> It was possible for tx queues to be stuck locked

I would still prefer to use "stopped" instead of locked here (and in the
subject).  But that's just me...


> if AP CSA finalization failed. In that case
> stop_ap nor do_stop woke the queues up.

Maybe "In that case *neither* stop_ap nor do_stop"...?

Otherwise looks good to me.

--
Luca.

