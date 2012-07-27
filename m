Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876Ab2G0K2u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 06:28:50 -0400
Date: Fri, 27 Jul 2012 12:18:41 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Chen, Chien-Chia" <machen@suse.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	kevin.chou@mediatek.com, woody.hung@mediatek.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00 : fix rt3290 resuming failed.
Message-ID: <20120727101840.GA2436@redhat.com> (sfid-20120727_122905_158310_6A66A1AC)
References: <1343372634-19870-1-git-send-email-machen@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1343372634-19870-1-git-send-email-machen@suse.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 27, 2012 at 03:03:54PM +0800, Chen, Chien-Chia wrote:
> This patch is going to fix the resuming failed from S3/S4
> for rt3290 chip.
> 
> Signed-off-by: Chen, Chien-Chia <machen@suse.com>
> CC-by: Kevin Chou <kevin.chou@mediatek.com>

Could you please post patches that compile? Also you did not set true
author of the patch. Additionally, since repost that patch with changes,
you should mark version of the patch and provide information about
changes, like for example here:
http://marc.info/?l=linux-wireless&m=134338186523059&w=2

Still patch does not include registers/values names, but if providing
such information is not possible, we will accept that.

Thanks
Stanislaw

