Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:36988 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932267Ab1BWNzl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 08:55:41 -0500
Received: by mail-ww0-f51.google.com with SMTP id 15so8122880wwe.32
        for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 05:55:40 -0800 (PST)
Subject: Re: [PATCH v2 1/2] wl12xx: use standard ALIGN() macro
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1298413627-19819-1-git-send-email-eliad@wizery.com>
References: <1298413627-19819-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 15:55:36 +0200
Message-ID: <1298469336.2104.26.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-23 at 00:27 +0200, Eliad Peller wrote:
> Use the standard ALIGN() macro instead of redefining similar macros.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> --- 

Applied both patches, thanks!

-- 
Cheers,
Luca.


