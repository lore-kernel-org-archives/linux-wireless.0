Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:53646 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755651Ab1DFSXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 14:23:44 -0400
Received: by mail-vw0-f54.google.com with SMTP id 18so1873215vws.41
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2011 11:23:42 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Update Power Save Exit Retries Packets
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301901331-19394-1-git-send-email-shahar_levi@ti.com>
References: <1301901331-19394-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 11:23:29 -0700
Message-ID: <1302114209.2366.38.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-04 at 10:15 +0300, Shahar Levi wrote:
> Reducing the retries of sending PS exit packets to the peer AP
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Can you explain in the commit message why this change is needed?


-- 
Cheers,
Luca.

