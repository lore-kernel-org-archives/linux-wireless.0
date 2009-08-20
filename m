Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox2.netikka.net ([213.250.81.203]:42012 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbZHTSLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 14:11:32 -0400
Message-ID: <4A8D91D5.4050008@mandriva.org>
Date: Thu, 20 Aug 2009 21:11:33 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: ASIC Felix <ic.felix@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k broken in 2.6.31-rc6
References: <8f3763990908200840p28cd6792qa16393dbbbe87e83@mail.gmail.com>
In-Reply-To: <8f3763990908200840p28cd6792qa16393dbbbe87e83@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ASIC Felix skrev:
> 
> 
> Hello Thomas,
> 
> your log shows "klogd: AR_INTR_SYNC_LOCAL_TIMEOUT",
> since "master-2009-08-14" I no longer see it in dmesg, I don't know
> with patch fixed it.
> 

Ah, ok thanks for that info...

> Perhaps you want to do a quick test with different dates of
> compat-wireless, it now allows compiling Atheros drivers only which
> makes it much quicker.
>

I'll take a look on that too...

> I assume you prepare wlan including ath9k for Mandriva kernels?
> 

Yep,
trying to fix some bugs...


For main kernel we try to stick with upstream kernel.org relases as it, 
as it's less maintenace that way...

So I'd really would like to try and get a working fix into 2.6.31 if 
possible...

For contrib kernels i could probably switch to wireless-testing in 
kernel-tmb as that is intended to be more "on the edge"...

--
Thomas
