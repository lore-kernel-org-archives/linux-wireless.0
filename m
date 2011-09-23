Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:58133 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399Ab1IWLQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 07:16:20 -0400
Received: by mail-bw0-f50.google.com with SMTP id zt19so3355642bkb.9
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 04:16:18 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Fix sdio test module functionality
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1315810837-30599-1-git-send-email-shahar_levi@ti.com>
References: <1315810837-30599-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 14:16:09 +0300
Message-ID: <1316776569.2157.729.camel@cumari> (sfid-20110923_131708_307576_70114171)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-12 at 10:00 +0300, Shahar Levi wrote: 
> The sdio test is broken due to changing in the io layer and FW
> macro name. Those fixes have been implemented in the wl12xx driver.
> Align the sdio test module with those fixes + small beautify
> indentation in the makefile.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Rephrased commit log, removed the change in the FW name (since it's
already done in another patch) and applied.


-- 
Cheers,
Luca.

