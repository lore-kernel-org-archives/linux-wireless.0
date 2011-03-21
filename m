Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53952 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262Ab1CURdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 13:33:03 -0400
Received: by mail-ww0-f42.google.com with SMTP id 4so3797440wwk.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 10:32:57 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: fix SG BT load value to reflect its new meaning
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1300723156-20978-1-git-send-email-coelho@ti.com>
References: <1300723156-20978-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 19:32:18 +0200
Message-ID: <1300728738.2593.242.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-21 at 17:59 +0200, Luciano Coelho wrote:
> The Soft Gemini BT load ratio value has changed its meaning with FW
> version 6.1.0.0.310.  It now means the passive scan compensation
> percentage during A2DP EDR.  Instead of 50, we need to use 200.
> 
> Fix the SG configuration accordingly.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

-- 
Cheers,
Luca.

