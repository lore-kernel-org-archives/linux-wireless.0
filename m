Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:60122 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935666Ab1ETMGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 08:06:21 -0400
Received: by mail-ew0-f43.google.com with SMTP id 20so1594406ewy.2
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 05:06:19 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] wl12xx: add support for rx streaming
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1305447030-10704-1-git-send-email-eliad@wizery.com>
References: <1305447030-10704-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 15:06:16 +0300
Message-ID: <1305893176.12586.1670.camel@cumari> (sfid-20110520_140623_918833_8B41D4F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-05-15 at 11:10 +0300, Eliad Peller wrote:
> wl12xx supports the "rx streaming" feature:
> 
> When in ps mode, and @timeout msecs have been passed since
> the last rx/tx, it issues trigger packets (QoS-null/PS-Poll packets,
> according to the ac type) in const intervals (in order to reduce
> the rx time).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied this series, thanks!

-- 
Cheers,
Luca.

