Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3HTVBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 17:01:44 -0400
Message-ID: <1377032500.13829.41.camel@jlt4.sipsolutions.net> (sfid-20130820_230147_445448_966CD7AA)
Subject: Re: [PATCH 11/16] wcn36xx: Add txrx.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org
Date: Tue, 20 Aug 2013 23:01:40 +0200
In-Reply-To: <1377020479-16935-12-git-send-email-k.eugene.e@gmail.com> (sfid-20130820_194157_436842_7EF6BDFF)
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
	 <1377020479-16935-12-git-send-email-k.eugene.e@gmail.com>
	 (sfid-20130820_194157_436842_7EF6BDFF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-20 at 19:41 +0200, Eugene Krasnikov wrote:

> +	/* Data frames served first*/
> +	if (is_low) {
> +		/*
> +		 * Sometimes in AP mode mac80211 is trying to send data
> +		 * frame to nobody. Why?
> +		 */
> +		if (!sta_priv)
> +			wcn36xx_warn("Sending data packet to nobody");

Umm, really? Have you heard of something called multicast? ;-)

johannes

