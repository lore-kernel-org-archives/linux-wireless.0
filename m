Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:48495 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab0IOV62 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 17:58:28 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 14:58:22 -0700
Date: Wed, 15 Sep 2010 14:58:26 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>
Subject: Re: [PATCH 2/2] compat: backport list_for_each_entry_continue_rcu
Message-ID: <20100915215826.GC1734@tux>
References: <1284583353-11456-1-git-send-email-hauke@hauke-m.de>
 <1284583353-11456-2-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1284583353-11456-2-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 01:42:33PM -0700, Hauke Mehrtens wrote:
> This is needed for new driver carl9170.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks, applied and pushed out!

  Luis
