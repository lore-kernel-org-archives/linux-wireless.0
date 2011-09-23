Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:57034 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446Ab1IWLhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 07:37:35 -0400
Received: by mail-bw0-f43.google.com with SMTP id s6so4038113bka.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 04:37:34 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Includes OFDM rates in IBSS mode
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1315220076-30153-1-git-send-email-shahar_levi@ti.com>
References: <1315220076-30153-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 14:37:30 +0300
Message-ID: <1316777850.2157.730.camel@cumari> (sfid-20110923_133738_618214_30549766)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-05 at 13:54 +0300, Shahar Levi wrote: 
> IBSS mode includes only 11B rates.
> Includes OFDM rates in IBSS mode. Note that IBSS connection is
> without ERP protection.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Rephrased commit log, removed one unnecessary comment and applied.
Thanks!

-- 
Cheers,
Luca.

