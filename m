Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44117 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbZL2B7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2009 20:59:38 -0500
Date: Mon, 28 Dec 2009 20:59:36 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/5] compat: Build fixes for compat-wireless
Message-ID: <20091229015936.GC30201@bombadil.infradead.org>
References: <1261495204-28966-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1261495204-28966-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 22, 2009 at 04:19:59PM +0100, Hauke Mehrtens wrote:
> Some fixes for compat.git and compat-wireless.git
> Build test for kernel 2.6.27 to 2.6.33 was successfull.
> For kernel 2.6.25 and 2.6.26 debugfs_remove_recursive is still missing.

Applied, thanks.

> PS: The last compat-wireless package at 
> http://wireless.kernel.org/download/compat-wireless-2.6/ is 2009-12-11.

Yeah, sorry about that I locked myself out of wireless.kernel.org, will fix that
soon. Been lazy during the holidays.

  Luis
