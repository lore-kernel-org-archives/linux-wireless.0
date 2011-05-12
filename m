Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:54523 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932755Ab1ELV3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 17:29:43 -0400
Received: by mail-ew0-f47.google.com with SMTP id 5so584627ewy.6
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 14:29:41 -0700 (PDT)
Subject: Re: [PATCH 0/7] wl12xx: scheduled scan implementation
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1305209740-30287-1-git-send-email-coelho@ti.com>
References: <1305209740-30287-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 00:29:38 +0300
Message-ID: <1305235778.12586.1059.camel@cumari> (sfid-20110512_232947_786264_88A43516)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-12 at 17:15 +0300, Luciano Coelho wrote:

[...]

> Luciano Coelho (7):
>   wl12xx: add configuration values for scheduled scan
>   wl12xx: listen to scheduled scan events
>   wl12xx: add scheduled scan structures and commands
>   wl12xx: implement scheduled scan driver operations and reporting
>   wl12xx: export scheduled scan state in debugfs
>   wl12xx: prevent sched_scan when not idle or not in station mode
>   wl12xx: remove unused flag WL1271_FLAG_IDLE_REQUESTED
> 

Applied the series.

-- 
Cheers,
Luca.

