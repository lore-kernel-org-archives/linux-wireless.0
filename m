Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:60378 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754049AbdJJBGB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 21:06:01 -0400
Date: Mon, 09 Oct 2017 18:05:55 -0700 (PDT)
Message-Id: <20171009.180555.71645109792027520.davem@davemloft.net> (sfid-20171010_030620_640639_403E6A3B)
To: keescook@chromium.org
Cc: tglx@linutronix.de, khc@pm.waw.pl, aditya.shankar@microchip.com,
        ganesh.krishna@microchip.com, gregkh@linuxfoundation.org,
        axboe@fb.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] timer: Remove meaningless .data/.function assignments
From: David Miller <davem@davemloft.net>
In-Reply-To: <20171010001032.GA119829@beast>
References: <20171010001032.GA119829@beast>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kees Cook <keescook@chromium.org>
Date: Mon, 9 Oct 2017 17:10:32 -0700

> Several timer users needlessly reset their .function/.data fields during
> their timer callback, but nothing else changes them. Some users do not
> use their .data field at all. Each instance is removed here.
> 
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Cc: Aditya Shankar <aditya.shankar@microchip.com>
> Cc: Ganesh Krishna <ganesh.krishna@microchip.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: devel@driverdev.osuosl.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org> # for staging
> Acked-by: Krzysztof Halasa <khc@pm.waw.pl> # for wan/hdlc*
> Acked-by: Jens Axboe <axboe@kernel.dk> # for amiflop
> ---
> This should go via the timer/core tree, please. It's been acked by each
> of the maintainers. Thanks!

For networking bits:

Acked-by: David S. Miller <davem@davemloft.net>
