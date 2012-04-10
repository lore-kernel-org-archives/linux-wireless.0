Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:56166 "EHLO
	na3sys009amx257.postini.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756296Ab2DJKOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 06:14:40 -0400
Received: by lbol5 with SMTP id l5so3124181lbo.35
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2012 03:14:38 -0700 (PDT)
Message-ID: <1334052849.10268.1.camel@cumari> (sfid-20120410_121443_715279_EE01333D)
Subject: Re: [PATCH] wl12xx: fix station channel switch
From: Luciano Coelho <coelho@ti.com>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Apr 2012 13:14:09 +0300
In-Reply-To: <1331563008-25481-1-git-send-email-victorg@ti.com>
References: <1331563008-25481-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-12 at 16:36 +0200, Victor Goldenshtein wrote: 
> Channel switch complete event wasn't handled
> properly in station mode, as we checked wrong
> CS flag.
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> ---

Applied and pushed, thanks!

-- 
Cheers,
Luca.

