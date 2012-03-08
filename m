Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:56096 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756918Ab2CHMqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 07:46:45 -0500
Received: by mail-lpp01m010-f54.google.com with SMTP id v3so886835lag.27
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 04:46:44 -0800 (PST)
Message-ID: <1331210801.18015.59.camel@cumari> (sfid-20120308_134656_467597_207D5871)
Subject: Re: [PATCH] wl12xx: implement SW Tx watchdog
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 08 Mar 2012 14:46:41 +0200
In-Reply-To: <1330805880-26659-1-git-send-email-arik@wizery.com>
References: <1330805880-26659-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-03-03 at 22:18 +0200, Arik Nemtsov wrote: 
> Track freed FW blocks during Tx. If no blocks were freed during a
> predefined timeout, initiate a HW recovery. This helps in situations
> when the FW watchdog fails.
> 
> Don't trigger recovery during activities that can temporarily stop
> Tx. This includes:
> - scanning
> - buffering packets for sleeping stations (AP role)
> - ROC on any role
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied and pushed to wl12xx.  Thanks!


-- 
Cheers,
Luca.

