Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53368 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab0HAGIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 02:08:42 -0400
Received: by pzk26 with SMTP id 26so1002346pzk.19
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jul 2010 23:08:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C54ACE7.1000205@linux.intel.com>
References: <4C54ACE7.1000205@linux.intel.com>
Date: Sun, 1 Aug 2010 09:08:41 +0300
Message-ID: <AANLkTin5jKr4BQdxooy4NRjmBja2Z8TPdgE-5RV++AQh@mail.gmail.com>
Subject: Re: Regulatory domain
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Sebastien Cayetanot <sebastien.cayetanot@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> country JP:
>        (2402 - 2472 @ 40), (N/A, 20)
>        (2457 - 2482 @ 20), (N/A, 20)
>        (2474 - 2494 @ 20), (N/A, 20), NO-OFDM
>        (4910 - 4930 @ 10), (N/A, 23)
>        (4910 - 4990 @ 40), (N/A, 23)
>        (4930 - 4950 @ 10), (N/A, 23)
>        (5030 - 5045 @ 10), (N/A, 23)
>        (5030 - 5090 @ 40), (N/A, 23)
>        (5050 - 5060 @ 10), (N/A, 23)
>        (5170 - 5250 @ 40), (N/A, 20)
>        (5250 - 5330 @ 40), (N/A, 20), DFS
>        (5490 - 5710 @ 40), (N/A, 23), DFS
>
> I would like to understand exactly what is displayed.
>
> - the number of line (xxx-xxx @ xx), (xx,xx) is equal to the number of channel which can be accessed
> - What is the meaning of each line and details on each parameter.
>

http://wireless.kernel.org/en/developers/Regulatory

(aaaa-bbbb @ c),(n/a, 23), XXX

each line is a range in frequencies (channels that fall between aaaa
and bbbb. c is the channel width (10 Mhz for Japan's narrow channels,
20 Mhz for regular channels and 40 Mhz for wide channels). 23 is the
maximum Tx power e.i.r.p. in db.
