Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:51382 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbcFWJas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 05:30:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] *** staging: wilc1000: Replace semaphores ***
Date: Thu, 23 Jun 2016 11:32:52 +0200
Message-ID: <4095728.J0WkMDCCsE@wuerfel> (sfid-20160623_113109_613917_8A8E9929)
In-Reply-To: <1466660512-14935-1-git-send-email-binoy.jayan@linaro.org>
References: <1466417419-13568-1-git-send-email-binoy.jayan@linaro.org> <1466660512-14935-1-git-send-email-binoy.jayan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, June 23, 2016 11:11:49 AM CEST Binoy Jayan wrote:
> 
> Thank you Arnd for patiently reviewing this patch series multiple times and
> apologies to everyone for spamming you inboxes with a patch (v3) that does
> not even build. It was due to an uncommited change in my git repo before
> generating the patch. It is corrected in v4.
> 
> This patchset [v4] is part of the second patch series for 'wilc1000'.
> The original patch series consisted 7 patches of which only the first 5
> are good. The patch 6 and 7 are being worked on in this series
> in a different way.
> 
> This patch series removes the semaphore 'sem' in 'wilc1000' and also
> restructures the implementation of kthread / message_queue logic with
> a create_singlethread_workqueue() / queue_work() setup.
> 
> These are part of a bigger effort to eliminate all semaphores
> from the linux kernel.
> 
> They build correctly (individually and as a whole).
> 
> NB: The changes are untested

Very nice work!

Whole series
Reviewed-by: Arnd Bergmann <arnd@arndb.de>

	ARnd
