Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:49355 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722Ab1D2UGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 16:06:13 -0400
Received: by mail-ew0-f51.google.com with SMTP id 6so1318945ewy.10
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 13:06:10 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Enable dynamic memory for 127x
From: Luciano Coelho <coelho@ti.com>
To: Ido Yariv <ido@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1303134310-31592-1-git-send-email-ido@wizery.com>
References: <1303134310-31592-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 23:06:06 +0300
Message-ID: <1304107566.12586.161.camel@cumari> (sfid-20110429_220615_961517_846EDEFE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-18 at 16:45 +0300, Ido Yariv wrote:
> The FW can dynamically manage its internal TX & RX memory pools, moving
> blocks from one pool to another when necessary. This can significantly
> improve performance. Currently this feature is enabled only for 128x.
> 
> Enable dynamic memory for 127x as well. Other parameters in the memory
> configuration structure may need to be fine tuned, as the optimal values
> for these may change once dynamic memory is enabled.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

Applied.

-- 
Cheers,
Luca.

