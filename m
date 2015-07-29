Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25435 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbbG2OVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 10:21:16 -0400
Date: Wed, 29 Jul 2015 17:20:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chandra S Gorentla <csgorentla@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: host_interface.c: Fix build warning
Message-ID: <20150729142037.GJ5180@mwanda> (sfid-20150729_162131_770998_F28FABCA)
References: <1438178819-12740-1-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1438178819-12740-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 29, 2015 at 07:36:59PM +0530, Chandra S Gorentla wrote:
> Fixed - warning: ‘*((void *)&strHostIFmsg+4).pu8Head’ may be used uninitialized 
> 

I can't reproduce this warning and the original code looks fine to me.

When you say the word "fix" it means the code is buggy.  Otherwise we
are just silencing warnings or cleaning up code.  It's not clear from
the patch description what is happening here, is it a bug or a warning
only?

regards,
dan carpenter

