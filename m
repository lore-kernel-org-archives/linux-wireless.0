Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53669 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab0HQBCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 21:02:05 -0400
Received: by gxk23 with SMTP id 23so2160788gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Aug 2010 18:02:03 -0700 (PDT)
Message-ID: <4C69DF79.2020900@lwfinger.net>
Date: Mon, 16 Aug 2010 20:01:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chris Vine <chris@cvine.freeserve.co.uk>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [RFT] BCM4312 users with DMA errors, please test!
References: <AANLkTimMhW7OX3DT7A3EDNaOnr577KmTv5w9C_mz19TG@mail.gmail.com>	<20100816204154.5100b604@boulder.homenet>	<20100816233544.40f0e1d4@boulder.homenet>	<4C69CF85.2020809@lwfinger.net>	<20100817010923.589d8063@boulder.homenet> <20100817011455.4919cfbb@boulder.homenet>
In-Reply-To: <20100817011455.4919cfbb@boulder.homenet>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2010 07:14 PM, Chris Vine wrote:
>>
>> I have reproduced it twice.  It is definitely the patch, in the sense
>> that it happens with the patch included (on two separate tests that I
>> have conducted) and never without.
>>
>> I do not doubt that you do not experience this effect.  However, you
>> don't experience the DMA bug either.
> 
> Out of interest, which version of the wl module do you have installed,
> as I wonder if that makes a difference?   (As I said in my e-mail on
> this, this problem only occurs if the wl module is available to the
> kernel.)

My wl came from hybrid-portsrc-x86_32-v5.60.48.36.tar.gz. My kernel is
2.6.36-rc1 from mainline.

Very strange that a patch to ssb, which is a module that cannot even load due to
being blacklisted, can cause this kind of problem. Are you warm or cold rebooting?

Larry
