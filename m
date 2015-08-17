Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18217 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbbHQOXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 10:23:46 -0400
Date: Mon, 17 Aug 2015 17:23:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com
Subject: Re: [PATCH 3/4] staging: wilc1000: remove WILC_ErrNo
Message-ID: <20150817142350.GG5558@mwanda> (sfid-20150817_162349_397853_B3A197FC)
References: <1439819071-30000-1-git-send-email-chaehyun.lim@gmail.com>
 <1439819071-30000-3-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439819071-30000-3-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2015 at 10:44:30PM +0900, Chaehyun Lim wrote:
> WILC_ErrNo is replaced by s32, then WILC_ErrNo typedef is removed.
> 

s32 is a weirdo type.  You should only specify the number of bit when it
is something required by the hardware.  Just use int.

regards,
dan carpenter

