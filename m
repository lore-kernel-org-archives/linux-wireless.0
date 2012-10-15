Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38265 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab2JOUyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 16:54:39 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so4796116wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2012 13:54:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349985702-21322-2-git-send-email-pontus.fuchs@gmail.com>
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com> <1349985702-21322-2-git-send-email-pontus.fuchs@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 15 Oct 2012 13:54:17 -0700
Message-ID: <CAB=NE6VDFb8Cw8Pc7xdjfdVaPV9mcz9WHKHMtg5=WgYD-Cf5KQ@mail.gmail.com> (sfid-20121015_225442_976568_9CEAC5E4)
Subject: Re: [PATCH 1/4] ar5523: Add main driver file
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	hch@lst.de, s.L-H@gmx.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 11, 2012 at 1:01 PM, Pontus Fuchs <pontus.fuchs@gmail.com> wrote:
> This driver is for the AR5523 chipset from Atheros. It was created
> in 2007 by Christoph Hellwig but it was never finished. I found it a
> couple if months ago and after some polishing it's working pretty
> fine.
>
> The driver was written with the FreeBSD driver (uath) as reference,
> which was written with the reverse-engineered windows driver as
> reference, hence the feature set is very limited. Station mode
> only, no HW crypto offload.
>
> Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>

If you guys want to help share code with the BSD family then my
recommendation would be to use a permissive license as we have on
ath9k for example. If that is not an objective then the existing
license is fine. I'm fine with this going into
drivers/net/wireless/ath/ but I unfortunately don't have time right
now to review the code.

  Luis
