Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:33774 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab0KATPR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 15:15:17 -0400
Subject: Re: [PATCH v2] wl1271: set wl->vif only if add_interface succeeded.
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288295203-12373-1-git-send-email-eliad@wizery.com>
References: <1288295203-12373-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 21:23:51 +0200
Message-ID: <1288639431.21112.51.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-28 at 21:46 +0200, ext Eliad Peller wrote:
> set wl->vif to the newly created interface only after the firmware booted
> successfully. on the way - make the function flow more clear.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thank you!
 

-- 
Cheers,
Luca.

