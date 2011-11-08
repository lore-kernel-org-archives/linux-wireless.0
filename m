Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab1KHPeZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 10:34:25 -0500
Subject: Re: [PATCH v3 3/3] mac80211: Save probe response data for bss
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320762928-6782-3-git-send-email-arik@wizery.com> (sfid-20111108_153610_339823_2D311245)
References: <1320762928-6782-1-git-send-email-arik@wizery.com>
	 <1320762928-6782-3-git-send-email-arik@wizery.com>
	 (sfid-20111108_153610_339823_2D311245)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 16:34:22 +0100
Message-ID: <1320766462.24797.7.camel@jlt3.sipsolutions.net> (sfid-20111108_163427_911513_3B6EA075)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 16:35 +0200, Arik Nemtsov wrote:

> +	new = dev_alloc_skb(resp_len);
> +	if (!new) {
> +		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
> +		       "response template\n", sdata->name);

I'm pretty sure that will already warn so the message is probably not
very useful.

johannes

