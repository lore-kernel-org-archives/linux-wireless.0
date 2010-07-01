Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab0GAGkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 02:40:03 -0400
Subject: Re: [PATCH] ath9k: fix TSF after reset on AR913x
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4C2BE5A8.9030003@openwrt.org>
References: <4C2A8AD4.8070504@openwrt.org>	<1277935351.17170.1.camel@mj>
	 <AANLkTim8NrVZfcJGi4NK_OhXBxEY0Lw9fdg1bcbzDU0X@mail.gmail.com>
	 <4C2BE5A8.9030003@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Jul 2010 08:39:56 +0200
Message-ID: <1277966396.3788.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-01 at 02:47 +0200, Felix Fietkau wrote:

> No, the TSF value at this point is not accurate. It differs
> semi-randomly by a few orders of magnitude from the time measured by the
> CPU timer. The value I put in above is just an approximation, but since
> making it completely accurate is impossible, I figured this is good
> enough, especially since the value will most likely not deviate much
> from what I've measured here.

Are you sure it doesn't depend on CPU speed as well since the driver is
involved here? Or DMA speed?

johannes

