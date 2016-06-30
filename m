Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57452 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbcF3KHp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 06:07:45 -0400
Message-ID: <1467281260.2499.4.camel@sipsolutions.net> (sfid-20160630_120747_607278_E68E76A0)
Subject: Re: [PATCH] mac80211: fix fq lockdep warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	ath10k@lists.infradead.org
Date: Thu, 30 Jun 2016 12:07:40 +0200
In-Reply-To: <1467201634-11060-1-git-send-email-michal.kazior@tieto.com> (sfid-20160629_135849_174305_00E9FE0A)
References: <1467026569-19329-1-git-send-email-michal.kazior@tieto.com>
	 <1467201634-11060-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20160629_135849_174305_00E9FE0A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-06-29 at 14:00 +0200, Michal Kazior wrote:
> Some lockdep assertions were not fulfilled and
> resulted in a kernel warning/call trace if driver
> used intermediate software queues (e.g. ath10k).
> 
> Existing code sequences should've guranteed safety
> but it's always good to be extra careful.
> 
Applied.

johannes
