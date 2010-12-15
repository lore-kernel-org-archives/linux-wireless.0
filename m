Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:63936 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab0LONSn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 08:18:43 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oBFDIfIk011066
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 15:18:41 +0200
Subject: Re: [PATCH] wl12xx: Change TX queue to be per AC
From: Luciano Coelho <luciano.coelho@nokia.com>
To: juuso.oikarinen@nokia.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1292226757-21614-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1292226757-21614-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 15:20:36 +0200
Message-ID: <1292419236.32385.5.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-12-13 at 09:52 +0200, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> With the current single-queue implementation traffic priorization is not
> working correctly - when using multiple BE streams and one, say VI stream,
> the VI stream will share bandwidth almost equally with the BE streams.
> 
> To fix the issue, implement per AC queues, which are emptied in priority
> order to the firmware. To keep it relatively simple, maintain a global
> buffer count and global queue stop/wake instead of per-AC.
> 
> With these changes, priorization appears to work just fine.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Thanks, Juuso! Applied.

-- 
Cheers,
Luca.

