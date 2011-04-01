Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:57706 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330Ab1DAJDb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 05:03:31 -0400
Received: by mail-wy0-f172.google.com with SMTP id 29so4323367wyb.17
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 02:03:30 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Handle duplicate calling of remove interface
From: Luciano Coelho <coelho@ti.com>
To: juuso.oikarinen@nokia.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301406230-18630-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1301406230-18630-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 12:04:07 +0300
Message-ID: <1301648647.1988.445.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-29 at 16:43 +0300, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> Because of the hardware recovery mechanism, its possible the
> __wl1271_op_remove_interface is called twice. Currently, this leads to a
> kernel crash even before a kernel WARNing can be issued.
> 
> Fix this.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Applied, thanks Juuso!

-- 
Cheers,
Luca.

