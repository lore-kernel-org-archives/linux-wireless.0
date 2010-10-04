Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:45712 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab0JDKqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 06:46:06 -0400
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o94AjYot032188
	for <linux-wireless@vger.kernel.org>; Mon, 4 Oct 2010 13:46:05 +0300
Subject: Re: [PATCH 2/2] wl1271: Move work-init calls to hw allocation
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285843408-6726-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1285843408-6726-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1285843408-6726-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 13:45:51 +0300
Message-ID: <1286189151.27112.12.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 12:43 +0200, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> Due to legacy reason, dating back to when the wl1251 and wl1271 still were
> a unified driver, some work-structures are initialized on hardware startup.
> 
> The hardware recovery code creates a scenario in which it is possible for a
> workstruct to be re-initialized while the work-function itself is running,
> which causes a kernel WARNing and a subsequent reboot.
> 
> To remedy this, move the work initialization calls to the hw allocation,
> which is the logically correct place for them anyway.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>

I'll apply this soon.


-- 
Cheers,
Luca.

