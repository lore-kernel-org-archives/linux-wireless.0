Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbcHKOvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 10:51:51 -0400
Date: Thu, 11 Aug 2016 16:48:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: helmut.schaa@googlemail.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] rt2x00usb: Fix error return code
Message-ID: <20160811144849.GA8018@redhat.com> (sfid-20160811_165154_991882_B4B93BF1)
References: <1470926334-24532-1-git-send-email-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1470926334-24532-1-git-send-email-christophe.jaillet@wanadoo.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 11, 2016 at 04:38:54PM +0200, Christophe JAILLET wrote:
> We know that 'retval = 0' because it has been tested a few lines above.
> So, if 'devm_kmalloc' fails, 0 will be returned instead of an error code.
> Return -ENOMEM instead.
> 
> Fixes: 8b4c0009313f ("rt2x00usb: Use usb anchor to manage URB")
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
