Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:44605 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab1A1GAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 01:00:16 -0500
Subject: Re: [PATCH 4/4] wl12xx: set supported_rates after association
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1296158081-16398-5-git-send-email-eliad@wizery.com>
References: <1296158081-16398-1-git-send-email-eliad@wizery.com>
	 <1296158081-16398-5-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 08:00:08 +0200
Message-ID: <1296194408.18570.425.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-27 at 21:54 +0200, ext Eliad Peller wrote:
> Instead of looking for supported_rates change on every tx packet,
> just extract the supported_rates after association completes (station only).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  

A very good change (and optimization.) This is how it should have been
from the beginning (but there was something with the old mac80211 stack
we used at the time of implementing this that created some issue.)

However, looks good to me:

Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

-Juuso

