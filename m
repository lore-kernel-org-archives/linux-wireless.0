Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39199 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbbKGUvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2015 15:51:15 -0500
Date: Sat, 7 Nov 2015 23:51:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: punit vara <punitvara@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
	chris.park@atmel.com, Austin Shin <austin.shin@atmel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH] Staging: wilc1000: Fix build break due to undeclared
 *wilc and implicit declaration of init_irq
Message-ID: <20151107205101.GK18797@mwanda> (sfid-20151107_215129_265716_F0FEAE84)
References: <1446895909-30052-1-git-send-email-punitvara@gmail.com>
 <20151107135427.GH18797@mwanda>
 <CABXAfNJWe78txO91YixoEZTO1n7q69LqN89UpDanrT8cA-jnyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABXAfNJWe78txO91YixoEZTO1n7q69LqN89UpDanrT8cA-jnyA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I haven't looked at it, sorry.  You'll have to figure it out or if you
complain to the original person who broken the build he can figure it
out.  You are still missing a Fixes tag.

regards,
dan carpenter
