Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:45095 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbZETOsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 10:48:17 -0400
Received: by gxk10 with SMTP id 10so868508gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2009 07:48:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090519175336.GF2691@tuxdriver.com>
References: <60ce8d250905191048t46e3848fw3416ecd793dab9d1@mail.gmail.com>
	 <20090519175336.GF2691@tuxdriver.com>
Date: Wed, 20 May 2009 22:48:17 +0800
Message-ID: <60ce8d250905200748p5984df0bl1984f0d3bdaf79b5@mail.gmail.com>
Subject: Re: Throughput is not changed when setting to a much higher bit rate
From: Dongas <dongas86@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/20 John W. Linville <linville@tuxdriver.com>:
> On Wed, May 20, 2009 at 01:48:32AM +0800, Dongas wrote:
>
>> Why the bandwidth is not changed when bit rate is changed to 11Mb/s?
>> Any thing wrong?
>
> More errors at higher bit rate, resulting in more retries?  Just a
> thought...
>
Is there a quick way to verify this possible reason? I'm using Libertas driver.

BTW, my sdio host driver is using polling mode to handle SDIO IRQ.
Could this be the cause of such poor performance?
(However I just can't believe the performance is so poor ,only around
1.1Mbps, with polling mode of SDIO IRQ)

Thanks a lot for the reply.

Regards
Dongas
