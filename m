Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49613 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbcDKMZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 08:25:57 -0400
Date: Mon, 11 Apr 2016 15:24:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alison Schofield <amsfield22@gmail.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Leo Kim <leo.kim@atmel.com>
Subject: Re: [PATCH] staging: wilc1000: move initialization of the config
 values
Message-ID: <20160411122447.GE4298@mwanda> (sfid-20160411_142635_474731_54D46240)
References: <20160408053515.GA10278@d830.WORKGROUP>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160408053515.GA10278@d830.WORKGROUP>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That may work, but I think it would be simpler to do this next to the
kzalloc() before we do the wilc->vif[i]->hif_drv = hif_drv; assignment.

regards,
dan carpenter

