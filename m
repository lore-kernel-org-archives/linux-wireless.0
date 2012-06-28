Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2F1TsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 15:48:15 -0400
Message-ID: <1340912894.5257.0.camel@jlt3.sipsolutions.net> (sfid-20120628_214817_871430_A5CDC0B7)
Subject: Re: [PATCH option A] bcma: use custom printing functions
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Date: Thu, 28 Jun 2012 21:48:14 +0200
In-Reply-To: <1340912688-3089-1-git-send-email-zajec5@gmail.com> (sfid-20120628_214513_551196_979CAEB6)
References: <1340912688-3089-1-git-send-email-zajec5@gmail.com>
	 (sfid-20120628_214513_551196_979CAEB6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 21:44 +0200, Rafał Miłecki wrote:

> +#define bcma_err(fmt, ...) \
> +	pr_err(KBUILD_MODNAME "-%d: " fmt, bus->num, ##__VA_ARGS__)

both of your options seem to rely on "bus" being a variable in the
context, is that really a good idea?

johannes

