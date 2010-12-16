Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:48426 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab0LPJRR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 04:17:17 -0500
Received: from vaebh101.NOE.Nokia.com (vaebh101.europe.nokia.com [10.160.244.22])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oBG9HBej025781
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 11:17:16 +0200
Message-ID: <4D09D80B.1020402@nokia.com>
Date: Thu, 16 Dec 2010 11:12:43 +0200
From: Roger Quadros <roger.quadros@nokia.com>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] wl12xx_sdio_test: rename files to match current style
References: <1292423499-5667-1-git-send-email-luciano.coelho@nokia.com>	 <1292423633.32385.9.camel@chilepepper>	 <1292424501.32385.10.camel@chilepepper>  <4D08DBDC.5070908@nokia.com> <1292490247.11205.14.camel@chilepepper>
In-Reply-To: <1292490247.11205.14.camel@chilepepper>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2010 11:04 AM, Luciano Coelho wrote:
> Hi Roger,
>
>
> I have a tree prepared with the latest wl12xx.git plus some patches that
> add support for our development platform (RX-71).
>
>
>> The only way to verify it is to load the module with the parameters rx=1 and
>> tx=1 and see if the "testing started" message appears.
>
> I tried it now, but I'm always getting this when loading the module:
>
> [  114.883514] wl12xx_sdio_test mmc2:0001:2: could not wake up chip
> [  114.889587] wl12xx_sdio_test: probe of mmc2:0001:2 failed with error 1
>
> Any clue what this is about?

Not sure. need to check.

>
>
>> what platform do you use to verify with mainline kernel&  sdio wl1271 ?
>
> I use both our RX-71 and a Beagleboard.  I have trees which work on
> both, let me know if you want to clone them from my local git.
>

Yes that will be helpful. Please provide me a link to your tree that works with 
RX-71.

-- 
regards,
-roger
