Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:60154 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754665Ab1LAOhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 09:37:52 -0500
Received: by lagj5 with SMTP id j5so1071865lag.34
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2011 06:37:49 -0800 (PST)
Subject: Re: [PATCH] wl12xx: Print nvs/fw file name if loading fails.
From: Luciano Coelho <coelho@ti.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1322663709-28128-1-git-send-email-pontus.fuchs@gmail.com>
References: <1322663709-28128-1-git-send-email-pontus.fuchs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 16:37:46 +0200
Message-ID: <1322750266.8996.35.camel@cumari> (sfid-20111201_153803_122457_6DEE15A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-30 at 15:35 +0100, Pontus Fuchs wrote: 
> Print the name of nvs/fw if request_firmware fails. This will make
> troubleshooting a bit easier.
> 
> Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
> ---

Applied.

-- 
Cheers,
Luca.

