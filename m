Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37476 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab0IOI1C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 04:27:02 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinM8vY7CygEN6DBR35WLkU-QOBwuiaRrpfwF6Mz@mail.gmail.com>
References: <1283376410-9999-1-git-send-email-ohad@wizery.com>
	<1283376410-9999-4-git-send-email-ohad@wizery.com>
	<AANLkTi=goLEUqM1XQ__PrGu4=Erw2utaNP4qFmSgRta2@mail.gmail.com>
	<20100906120716.GE20903@n2100.arm.linux.org.uk>
	<AANLkTikAFCd+3ggZKhQXY=+bG==KgLkv3qNVdEGa=GBX@mail.gmail.com>
	<AANLkTinM8vY7CygEN6DBR35WLkU-QOBwuiaRrpfwF6Mz@mail.gmail.com>
Date: Wed, 15 Sep 2010 10:27:00 +0200
Message-ID: <AANLkTikSP874gnsPrc_M1LJYNpjX+Lz3-5=Bk5_HtgP+@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] wireless: wl12xx: add platform data passing support
From: Vitaly Wool <vitalywool@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	akpm@linux-foundation.org, Nicolas Pitre <nico@fluxnic.net>,
	Tony Lindgren <tony@atomide.com>, linux-mmc@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-wireless@vger.kernel.org, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	linux-omap@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/15 Ohad Ben-Cohen <ohad@wizery.com>:
>> Sorry for pushing at this, but why would you mark data that's meant to
>> be used after init phase as __initdata?
>
> I can remove the first copying as well if Russell is ok with it.

I personally think it's not worth it. This copying basically happens
only once and this point is soooo irrelevant. My position therefore
is: let's get the current implementation in, and if Michal is
uncomfortable with that, he can come up with the patch. Let's
concentrate on the real problems.

Thanks,
   Vitaly
