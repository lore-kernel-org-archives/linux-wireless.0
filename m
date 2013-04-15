Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab3DOJYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 05:24:19 -0400
Message-ID: <1366017844.8361.7.camel@jlt4.sipsolutions.net> (sfid-20130415_112423_489763_4F24A7E2)
Subject: Re: [Patch] mac80211: add rts-cts for dynamic SMPS stations
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivekananda Holla <vivekanandah@posedge.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 15 Apr 2013 11:24:04 +0200
In-Reply-To: <516B9F21.2080304@posedge.com>
References: <516B9F21.2080304@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek,

Please work with some of your colleagues at posedge to submit a proper
patch. This is formatted completely wrongly in many ways.

> +        if (dyn_smps) {
> +            if ((info->control.rates[i].idx > 7) &&
> +                (info->control.rates[i].idx != 32))

This is also completely wrong. (hint, there are non-HT bitrates still)

johannes

