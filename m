Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:36647 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768Ab1DTR6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 13:58:37 -0400
Received: by mail-ey0-f180.google.com with SMTP id 24so405547eyg.39
        for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2011 10:58:36 -0700 (PDT)
Subject: Re: [PATCH v2] wl12xx: Set correct REF CLK and TCXO CLK values to
 the FW
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301828094-29569-1-git-send-email-shahar_levi@ti.com>
References: <1301828094-29569-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 21:00:58 +0300
Message-ID: <1303322458.1988.738.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-03 at 13:54 +0300, Shahar Levi wrote:
> Fix mismatch between the REF CLK and TCXO CLK information that is
> set in the platform data and the NVS, so we override what comes
> from the NVS and replace it with what comes from the platform data.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Applied with a small fix in a comment.  Thank you!

-- 
Cheers,
Luca.

