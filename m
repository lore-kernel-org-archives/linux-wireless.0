Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44335 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab1CGPWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 10:22:12 -0500
MIME-Version: 1.0
In-Reply-To: <20110307151201.GC2664@tuxdriver.com>
References: <AANLkTik9To0Rkq2FRqQFB2wNu0kyJ7CzyBek2jBp36Cb@mail.gmail.com>
	<20110303135942.GA8969@tuxdriver.com>
	<AANLkTi=mtaf==aLfOFK06EgmbdZ4aVk3GEthw7PwuSTS@mail.gmail.com>
	<20110307151201.GC2664@tuxdriver.com>
Date: Mon, 7 Mar 2011 20:52:10 +0530
Message-ID: <AANLkTi=7RSdKhzGazQFUnBZqzMQskOSHq=7E08uan2vu@mail.gmail.com>
Subject: Re: WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536
 ath_stoprecv+0xc8/0xda [ath9k]()
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Justin Mattock <justinmattock@gmail.com>,
	linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ath9k-devel@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 7, 2011 at 8:42 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Sun, Mar 06, 2011 at 12:47:05AM -0800, Justin Mattock wrote:
>
>> full dmesg here:
>> http://fpaste.org/5JQp/
>> let me know if I need to supply any info(also I can try a bisect, but
>> am in the middle of changing residencies, so it might not be right
>> away)
>
> One of the Atheros guys suggested that you change a DMA timeout value.
> Did you try that?

John it looks like increasing the timeout also does not seems to help.
A user reported this issue in ath9k developer list and he told that
increasing the timeout did not fix this issue.

>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
