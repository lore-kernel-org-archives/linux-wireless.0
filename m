Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37669 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761304Ab0HFQbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 12:31:12 -0400
Received: by wwj40 with SMTP id 40so9256066wwj.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 09:31:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C5B27BE.8010708@lwfinger.net>
References: <4C5B27BE.8010708@lwfinger.net>
Date: Fri, 6 Aug 2010 18:31:11 +0200
Message-ID: <AANLkTi=-Jc9XjD-gqwtUyUnM768wvv3GzzwhJNtkwYKK@mail.gmail.com>
Subject: Re: Interesting development regarding b43 DMA ERROR
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/8/5 Larry Finger <Larry.Finger@lwfinger.net>:
> Yesterday, I had to go back to kernel 2.6.34 for a test of code to avoid ssb
> load freezeups on my HP Mini 110 Netbook, which has the SPROM at offset 0x0800,
> not 0x1000. As I had been using b43 for this BCM4312 (14e4:4315) card in DMA
> mode without any problems, I was quite surprised to see the dreaded DMA errors.
> I had attributed the lack of errors with wireless testing to be due to the AMI,
> not Phoenix, BIOS in this machine. When I switched to mainline ('git describe'
> reports it as v2.6.35-3370-gcdd854b), again it works.
>
> AFAIK, none of any fixes that were put into wt to try to solve this problem had
> any affect, yet the device now works here.
>
> Is anyone else that had/has the DMA problem running 2.6.35 + updates from the
> linux-2.6.git tree? If so, does your BCM4312 now work with b43, or is my box
> special?

Interesting. It means some patch that gone mainline fixed it and it
was submitted using other tree than w-t, right?

Would you care to bisect this?

-- 
Rafał
