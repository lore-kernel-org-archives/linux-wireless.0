Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:37475 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935666Ab1ETMHX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 08:07:23 -0400
Received: by mail-ew0-f44.google.com with SMTP id 19so1524021ewy.31
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 05:07:22 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Enable beacon early termination in 2.4G band
 only
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1305549330-28478-1-git-send-email-shahar_levi@ti.com>
References: <1305549330-28478-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 15:07:19 +0300
Message-ID: <1305893239.12586.1671.camel@cumari> (sfid-20110520_140729_163863_1D5146E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-16 at 15:35 +0300, Shahar Levi wrote:
> Beacon early termination have minor effect in 5G band and also
> mask channel switch IE Beacons.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Applied with a slightly reworded commit message.

-- 
Cheers,
Luca.

