Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40844 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab0KLUJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 15:09:45 -0500
Received: by iwn10 with SMTP id 10so3863523iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 12:09:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTin5LRUFKtfbZZQR-t4-JHJ1TdHmPMeyX0AsCmC-@mail.gmail.com>
References: <55285.71229.qm@web56801.mail.re3.yahoo.com> <AANLkTikjfrAjPBVjS86B-9fYpEREOkSwR-m5_YsVXy9-@mail.gmail.com>
 <AANLkTin5LRUFKtfbZZQR-t4-JHJ1TdHmPMeyX0AsCmC-@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 12 Nov 2010 12:09:23 -0800
Message-ID: <AANLkTimAm=WXN3MWHAd4s-iViqAn56J8VVi4Q4ip_-mR@mail.gmail.com>
Subject: Re: [PATCH 4/4] compat-wireless: remove obsolete load scripts
To: Shinhaeng Oh <shoh@mmlab.snu.ac.kr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 10:25 PM, Shinhaeng Oh <shoh@mmlab.snu.ac.kr> wrote:
> Hello. Mr.Rodriguez.
>
> I'm from Korea at Seoul Nat'l University graduate student. (mmlab.snu.ac.kr)
>
> Also, I'm interested in ath9k (802.11n)
>
> In my compile procedure,
>
> 1. make unload
>
> 2. make
>
> 3. make install
>
> 4. make wlload
>
> However, I have some question for your PATCH
> (compat-wireless-2010-10-23.tar.bz2)
>
> After this PATCH, wlload is gone.
>
> wlload.sh was exists in compat-wireless-2010-10-22.tar.bz2
>
> Is there any reason there is no wlload.sh?
>
> And then, how can I load and test the lan-card from my computer without
> "make wlload"?
>
> I'd really appreciate and thankful for your reply
>
> Thank you.
>
>
> Best Regards,
>
> Shinhaeng
>
> 2010/11/9 Mingu Cho <mgcho@mmlab.snu.ac.kr>
>>

Its gone. Don't use it. Load the module you know you need or reboot.
Simple as that.

 Luis
