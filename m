Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab1KUIuH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 03:50:07 -0500
Date: Mon, 21 Nov 2011 09:52:15 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] iwlegacy: off by one in iwl3945_hw_build_tx_cmd_rate()
Message-ID: <20111121085150.GC2787@redhat.com> (sfid-20111121_095012_854124_09533F3A)
References: <20111120210400.GB7354@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111120210400.GB7354@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 21, 2011 at 12:04:00AM +0300, Dan Carpenter wrote:
> We use "rate_index" like this:
> 	rate = iwl3945_rates[rate_index].plcp;
> The iwl3945_rates[] array has IWL_RATE_COUNT_3945 elements so the
> limit here is off by one.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks Dan. I queued patch into iwlegacy github tree on top
of my current changes, otherwise there would be problems with
merging.

Thanks
Stanislaw
