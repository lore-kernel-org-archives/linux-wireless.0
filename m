Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:57066 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754105Ab2FFISw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:18:52 -0400
Received: by lahc1 with SMTP id c1so5465970lah.32
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 01:18:50 -0700 (PDT)
Message-ID: <1338970728.7078.3.camel@cumari.coelho.fi> (sfid-20120606_101857_488782_67770076)
Subject: Re: [PATCH] wlcore: wait for roc complete only for the first roc
 command
From: Luciano Coelho <coelho@ti.com>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, arik@wizery.com
Date: Wed, 06 Jun 2012 11:18:48 +0300
In-Reply-To: <1337000858-13620-1-git-send-email-victorg@ti.com>
References: <1337000858-13620-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-14 at 16:07 +0300, Victor Goldenshtein wrote:
> In some multi role scenarios the driver might send multi
> roc requests without sending a croc first, the fw queues
> those requests and starts service the next roc request as
> soon as the driver sends a croc for the previous one. So,
> if the fw rocs on channel X and driver asks to roc also
> on channel Y, the fw will not start service Y (and will
> not send roc complete event for this request) until the
> driver releases the fw with croc X.
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> Signed-off-by: Igal Chernobelsky <igalc@ti.com>
> ---

Applied and pushed!

--
Luca.

