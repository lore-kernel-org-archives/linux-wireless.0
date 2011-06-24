Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:60282 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755515Ab1FXTcy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 15:32:54 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <error27@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	"open list:NETWORKING [WIREL..." <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Fri, 24 Jun 2011 12:32:36 -0700
Subject: RE: [patch] mwifiex: restore handling of NULL parameters
Message-ID: <477F20668A386D41ADCC57781B1F704307FF9744E8@SC-VEXCH1.marvell.com> (sfid-20110624_213306_494275_2F3FBDAA)
References: <20110624133335.GP14591@shale.localdomain>
In-Reply-To: <20110624133335.GP14591@shale.localdomain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> Prior to a5ffddb70c5cab "mwifiex: remove casts of void pointers" the
> code assumed that the data_buf parameter could be a NULL pointer.
> The patch preserved some NULL checks but not consistently, so there
> was a potential for NULL dereferences and it changed the behavior.

Thanks for the catch!

> This patch restores the original behavior.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Best regards,
Bing
 
