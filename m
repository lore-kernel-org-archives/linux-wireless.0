Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab2DEKFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 06:05:55 -0400
Date: Thu, 5 Apr 2012 12:04:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH v2 3/4] rt2800: initialize queues before giving up due to
 DMA error
Message-ID: <20120405100449.GC2378@redhat.com> (sfid-20120405_120559_430391_44EAE138)
References: <1333417250-24560-1-git-send-email-kubakici@wp.pl>
 <1333417250-24560-4-git-send-email-kubakici@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1333417250-24560-4-git-send-email-kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 03, 2012 at 03:40:49AM +0200, Jakub Kicinski wrote:
> Don't immediately abort .start if DMA is busy before we
> initialize the queues. Some drivers do not deinitialize
> queues properly and we would fail to take over after them.
> 
> This behaviour is consistent with legacy driver.
> 
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>
