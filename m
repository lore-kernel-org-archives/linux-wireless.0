Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:51034 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754443Ab2FMTGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 15:06:21 -0400
Received: by lahj13 with SMTP id j13so610651lah.25
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 12:06:18 -0700 (PDT)
Message-ID: <1339614376.10534.67.camel@cumari.coelho.fi> (sfid-20120613_210631_899099_3C82417F)
Subject: Re: [PATCH] wlcore: declare interface combinations
From: Luciano Coelho <coelho@ti.com>
To: Yoni Divinsky <yoni.divinsky@ti.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Date: Wed, 13 Jun 2012 22:06:16 +0300
In-Reply-To: <1339608556-23346-1-git-send-email-yoni.divinsky@ti.com>
References: <1339608556-23346-1-git-send-email-yoni.divinsky@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-13 at 20:29 +0300, Yoni Divinsky wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> Advertise to the stack that the wlcore driver
> supports multiple interfaces for a single device.
> This is required in order to be able to run
> multirole with mac80211.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
> ---

Applied and pushed, thanks guys!

--
Luca.

