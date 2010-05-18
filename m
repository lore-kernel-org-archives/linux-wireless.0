Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58261 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab0ERLN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 07:13:56 -0400
Subject: Re: [PATCH] ath9k_htc: Use proper station add/remove callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <19442.25652.916516.143181@gargle.gargle.HOWL>
References: <19442.25652.916516.143181@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 13:13:48 +0200
Message-ID: <1274181228.3762.78.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-18 at 15:26 +0530, Sujith wrote:
> sta_add/sta_remove are the callbacks that can sleep.
> Use them instead of sta_notify.
> 
> Sigh. What a dumb fsckup.

Not really your fault? The sleeping ones are quite new.

johannes

