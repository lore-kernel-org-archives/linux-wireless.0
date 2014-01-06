Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39824 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751AbaAFTBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 14:01:11 -0500
Received: by mail-pa0-f46.google.com with SMTP id kp14so17169410pab.33
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 11:01:11 -0800 (PST)
Message-ID: <52CAFD73.9060900@lwfinger.net> (sfid-20140106_200117_265159_FE59B04A)
Date: Mon, 06 Jan 2014 13:01:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Julian Gordon <jewelsofthought@gmail.com>,
	Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: r92su driver for realtek rtl8192su usb wireless adapter
References: <CAP+W=6QCwL1hbz5fRKuBr7dCS58_fVFTQ-mFjgW5rTr6y6QO-w@mail.gmail.com>	<1655218.I1JJMSx2BO@debian64> <CAP+W=6Q1=PCcA2T5gaar960Zek8=sO05UjouwWfX6SpDjrcL6Q@mail.gmail.com>
In-Reply-To: <CAP+W=6Q1=PCcA2T5gaar960Zek8=sO05UjouwWfX6SpDjrcL6Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2014 07:38 AM, Julian Gordon wrote:
> Christian,
>
> Thanks for the reply. After I sent the email, I continued to do some more
> investigation, and am presently downloading the OS's needed to upgrade from
> 12.04 to 13.10 (or 12). I was hoping to be able to remain on 12.04 for its
> LTS.
>
> Oh well, that's life in the boonies.
>
> Thanks for this useful tool - especially of those of us living out of the
> mainstream, down in the far south of Africa where our device choice is much
> more limited.

You can update the kernel in 12.04 LTS to 3.12.0-031200-generic (that is the 
32-bit version) without changing the rest of the system. I just did this in a VM 
and it worked fine. There are a number of postings on how to do this.

Larry


