Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:11339 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab0LRUIQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 15:08:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 18 Dec 2010 12:08:00 -0800
Date: Sat, 18 Dec 2010 12:08:12 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>
Subject: Re: [PATCH 1/3] compat: backport skb_checksum_start_offset
Message-ID: <20101218200812.GD1812@tux>
References: <1292625698-17289-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1292625698-17289-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 17, 2010 at 02:41:36PM -0800, Hauke Mehrtens wrote:
> This is needed by atlx, atl1c and atl1e.
 

Applied all and pushed, thanks!

  Luis
