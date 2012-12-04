Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:52200 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751976Ab2LDOQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:16:21 -0500
Message-ID: <50BE05AF.1090509@posedge.com> (sfid-20121204_151633_250873_ABC743E3)
Date: Tue, 04 Dec 2012 19:46:15 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Saravana <saravanad@posedge.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add debugfs file for mic failure
References: <50BE03F4.2060605@posedge.com>
In-Reply-To: <50BE03F4.2060605@posedge.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +static ssize_t key_mic_failures_read(struct file *file, char __user *userbuf,
> +					size_t count, loff_t *ppos)
> +
There is an extra line below the function header.
This will be removed in the Patch v2.
> +{

