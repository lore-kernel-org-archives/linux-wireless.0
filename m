Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37556 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab1HIDHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 23:07:06 -0400
Received: by pzk37 with SMTP id 37so9335550pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 20:07:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=SED0RLmQot2yAeAmv53Yitn+RV31tf2zWOmBHXzq_0w@mail.gmail.com>
References: <CAH-LUqry4TKAvnojAo39QfT-Wy_BN94SYJEiCCRX4hrb=RcfwQ@mail.gmail.com>
	<CAJ-Vmo=SED0RLmQot2yAeAmv53Yitn+RV31tf2zWOmBHXzq_0w@mail.gmail.com>
Date: Tue, 9 Aug 2011 11:07:05 +0800
Message-ID: <CAH-LUqrHifnWY=V-p6zs0RPoLtqQadVysQ6ZLj0tEXXbuF_e+w@mail.gmail.com> (sfid-20110809_050723_183618_9EDE555B)
Subject: Re: AR9285 Wireless 80211n mode get only 25Mbit with Linux 2.6.38.8
 and compat-wireless-2.6.38.2-2
From: Dane Shih <daneshih1981@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/8/9 Adrian Chadd <adrian@freebsd.org>:
> On 9 August 2011 11:00, Dane Shih <daneshih1981@gmail.com> wrote:
>
>> /etc/modprobe.d/ath9.conf
>> options ath9k nohwcrypt=1
>> modprobe -v ath9k
>
> Out of curiousity, why are you using nohwcrypt=1 ?
>
>
> adrian
>

http://ubuntuforums.org/showthread.php?t=1746326
http://www.fedoraforum.org/forum/showthread.php?t=252404
