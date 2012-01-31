Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:33837 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973Ab2AaHnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 02:43:19 -0500
Received: by lahi5 with SMTP id i5so2211979lah.4
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 23:43:17 -0800 (PST)
Subject: Re: [PATCH 0/7] wl12xx: add some psm/suspend features
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1327935525-24361-1-git-send-email-eliad@wizery.com>
References: <1327935525-24361-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jan 2012 09:43:13 +0200
Message-ID: <1327995793.3626.128.camel@cumari> (sfid-20120131_084411_118648_3AE934FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-30 at 16:58 +0200, Eliad Peller wrote: 
> Add some psm / suspend features:
> * Add the ability to force psm (by default, the fw uses dynamic ps)
> * Use differnet wake up conditions on suspend
> * Add pattern support to wowlan triggers
> 
> Eyal Shapira (4):
>   wl12xx: Set different wake up conditions in case of suspend
>   wl12xx: add suspend_listen_interval debugfs file
>   wl12xx: add forced_ps mode
>   wl12xx: add forced_ps debugfs file
> 
> Pontus Fuchs (3):
>   wl12xx: Add rx data filter commands
>   wl12xx: Add functions for managing rx data filters
>   wl12xx: Add support for WoWLAN packet pattern trigger

Skipping this patchset on Eliad's request.  He will send a v2 with some
squashes and new patches soon.

-- 
Cheers,
Luca.

