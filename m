Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:42357 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3GXPdv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 11:33:51 -0400
Received: by mail-oa0-f51.google.com with SMTP id i4so1300601oah.24
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jul 2013 08:33:51 -0700 (PDT)
Message-ID: <51EFF3DD.80000@lwfinger.net> (sfid-20130724_173355_225276_A3073EF5)
Date: Wed, 24 Jul 2013 10:33:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vihang Patel <vihang08@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Fwd: TP-LINK 8200ND
References: <CA+Gu+Kx3RNkenmHD4dGP5NxC1zzq9sxwjdRxuj5qLFCg32DLeQ@mail.gmail.com> <CA+Gu+Ky5rCwCrWJkCKXsPEFodaARdf5DkmES3TN_UNuUqTnYVA@mail.gmail.com>
In-Reply-To: <CA+Gu+Ky5rCwCrWJkCKXsPEFodaARdf5DkmES3TN_UNuUqTnYVA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/24/2013 08:50 AM, Vihang Patel wrote:
> Hi,
>
> I understand there was a thread on linux drivers for TP-LINK8200ND
> with rtl8192cu chipset, but it ran cold with no resolution. I was
> wondering if there if anyone found a resolution on that.
>
> I have tried installing the drivers provided by realtek as well on
> both Ubuntu 12.004 and 13.04. Scorched the internet, and was able to
> get it to detect the device but it wont connect to any of the Wireless
> networks.
>
> Any help would be helpful.

The USB ID has been added to the mainline and stable kernels; however, the 
device does not work for me. The latest vendor driver sent privately to me can 
make a connection; however, the throughput is less than 1 Mbps. I have not yet 
had a chance to investigate as this card is low on my priority list.

I have added the Realtek developer to this reply (Bcc). Perhaps the company has 
made some progress; however, when I last contacted them, they did not have an 
instance of this particular card. It seems that your only viable option at this 
time would probably be the Windows driver with ndiswrapper. I have not tested 
this option.

Larry


