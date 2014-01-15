Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38249 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAONRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:17:37 -0500
Message-ID: <1389791853.4338.3.camel@jlt4.sipsolutions.net> (sfid-20140115_141740_843781_EC0112E2)
Subject: Re: [RFC 3/9] mac80211: move csa_active setting in STA CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Jan 2014 14:17:33 +0100
In-Reply-To: <1389787494-7361-4-git-send-email-michal.kazior@tieto.com> (sfid-20140115_130927_603522_15891A3C)
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
	 <1389787494-7361-4-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140115_130927_603522_15891A3C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 13:04 +0100, Michal Kazior wrote:
> The sdata->vif.csa_active could be left set after,
> e.g. channel context contraints check fail in STA

typo: constraints


