Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59671 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab1AEXVu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 18:21:50 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 15:21:32 -0800
Date: Wed, 5 Jan 2011 15:21:48 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>
Subject: Re: [PATCH 1/4] compat-wireless: fix power managemnet backport
Message-ID: <20110105232148.GG10391@tux>
References: <1293891981-22151-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1293891981-22151-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 01, 2011 at 06:26:18AM -0800, Hauke Mehrtens wrote:
> Include backported power management support under the same condition as
> the new one is integrated.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied and pushed all, thanks!

  Luis
