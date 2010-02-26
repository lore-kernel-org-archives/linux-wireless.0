Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:38226 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936021Ab0BZNGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 08:06:48 -0500
Subject: Re: [PATCH] libertas: add auto auth mode feature
From: Marcel Holtmann <marcel@holtmann.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
In-Reply-To: <1267146996-3725-1-git-send-email-bzhao@marvell.com>
References: <1267146996-3725-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Feb 2010 14:08:30 +0100
Message-ID: <1267189710.18491.60.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

> Auto auth mode is enabled by default. If user doesn't specify the
> auth mode, while association driver will first try with open mode
> and then with shared key mode. If user specifies an auth mode,
> auto auth is disabled and driver will not try association with
> another auth mode.

I agree with Holger that the conversion into being fully cfg80211
compliant is basically the only way to go forward. Especially since
Holger and Samuel are already have patches for it.

However from a different point, how can you try open mode first and
detect a failure. Isn't this suppose to be the other way around, try
shared first and then fall back to open?

Regards

Marcel


