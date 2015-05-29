Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37820 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbbE2LLz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 07:11:55 -0400
Message-ID: <1432897913.2104.8.camel@sipsolutions.net> (sfid-20150529_131217_982833_A48B2AF1)
Subject: Re: [PATCH next 1/2] net: rfkill: gpio: make better use of gpiod API
From: Johannes Berg <johannes@sipsolutions.net>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Cc: linux-wireless@vger.kernel.org, kernel@pengutronix.de
Date: Fri, 29 May 2015 13:11:53 +0200
In-Reply-To: <1432806373-17372-2-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1432806373-17372-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1432806373-17372-2-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-28 at 11:46 +0200, Uwe Kleine-König wrote:
> Since 39b2bbe3d715 (gpio: add flags argument to gpiod_get*() functions)
> which appeared in v3.17-rc1, the gpiod_get* functions take an additional
> parameter that allows to specify direction and initial value for output.
> 
> Furthermore there is devm_gpiod_get_optional which is designed to get
> optional gpios.
> 
> Simplify driver accordingly.
> 
> Note this makes error checking more strict because only -ENOENT is
> ignored when searching for the GPIOs which is good.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Applied.

johannes

