Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3HSK25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 06:28:57 -0400
Message-ID: <1376908128.14734.7.camel@jlt4.sipsolutions.net> (sfid-20130819_122859_811362_02553DCF)
Subject: Re: [PATCH] net: rfkill: Check the return value of
 regulator_enable()
From: Johannes Berg <johannes@sipsolutions.net>
To: Fabio Estevam <festevam@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Date: Mon, 19 Aug 2013 12:28:48 +0200
In-Reply-To: <1376775367-17068-1-git-send-email-festevam@gmail.com> (sfid-20130817_233637_078502_E8973748)
References: <1376775367-17068-1-git-send-email-festevam@gmail.com>
	 (sfid-20130817_233637_078502_E8973748)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-08-17 at 18:36 -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Fix the following build warning:

I already have a fix for this in my tree.

johannes

