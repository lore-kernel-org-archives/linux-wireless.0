Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29530 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab1CaTRs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 15:17:48 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 12:17:23 -0700
Date: Thu, 31 Mar 2011 12:17:44 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: "mcgrof@gmail.com" <mcgrof@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] compat: backport netdev_refcnt_read.
Message-ID: <20110331191744.GB7457@tux>
References: <1301588495-16583-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1301588495-16583-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 31, 2011 at 09:21:32AM -0700, Hauke Mehrtens wrote:
> Backport of upstream commit:
> 	29b4433d991c88d86ca48a4c1cc33c671475be4b
> 	net: percpu net_device refcount
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---

Great, thanks, applied and pushed!

  Luis
