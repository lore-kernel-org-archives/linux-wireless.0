Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:35101 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051Ab1CCPj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 10:39:28 -0500
Received: by mail-ey0-f179.google.com with SMTP id 5so412791eyg.24
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 07:39:27 -0800 (PST)
Subject: Re: [PATCH] WLAN: fix the path to the wl12xx firmwares
From: Luciano Coelho <coelho@ti.com>
To: Sebastien Jan <s-jan@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1298467516-9092-1-git-send-email-s-jan@ti.com>
References: <1298467516-9092-1-git-send-email-s-jan@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 17:39:17 +0200
Message-ID: <1299166757.7039.3.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-23 at 14:25 +0100, Sebastien Jan wrote:
> Validated FW loading on a Ubuntu Natty alpha image, on a pandaboard
> (embedding a WL1271).
> 
> Signed-off-by: Sebastien Jan <s-jan@ti.com>
> ---

Applied with small modifications: merged with the latest code and
changed the description to something more generic (this is not only
about pandaboard).

Thanks Jan!

-- 
Cheers,
Luca.

