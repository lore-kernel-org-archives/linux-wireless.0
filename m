Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41707 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab1HIDwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 23:52:01 -0400
Received: by ywf7 with SMTP id 7so646300ywf.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 20:52:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH-LUqrVkiriXSfdqTw_L_AxnCVbSHQLrLzWMkriiRv9dmT2Xw@mail.gmail.com>
References: <CAH-LUqry4TKAvnojAo39QfT-Wy_BN94SYJEiCCRX4hrb=RcfwQ@mail.gmail.com>
	<CAJ-Vmo=SED0RLmQot2yAeAmv53Yitn+RV31tf2zWOmBHXzq_0w@mail.gmail.com>
	<CAH-LUqrHifnWY=V-p6zs0RPoLtqQadVysQ6ZLj0tEXXbuF_e+w@mail.gmail.com>
	<CAJ-VmokNRqHu005G_-_Zt4Ftgg0UL+AHBXpN39So5WNKt1m2=g@mail.gmail.com>
	<CAH-LUqrVkiriXSfdqTw_L_AxnCVbSHQLrLzWMkriiRv9dmT2Xw@mail.gmail.com>
Date: Tue, 9 Aug 2011 11:52:00 +0800
Message-ID: <CAJ-VmokHnUeu1pfv5jjwy=wRHmr=5=sgxf2KeprFNXCq88U7Nw@mail.gmail.com> (sfid-20110809_055205_651602_99E64AC6)
Subject: Re: AR9285 Wireless 80211n mode get only 25Mbit with Linux 2.6.38.8
 and compat-wireless-2.6.38.2-2
From: Adrian Chadd <adrian@freebsd.org>
To: Dane Shih <daneshih1981@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 August 2011 11:18, Dane Shih <daneshih1981@gmail.com> wrote:
> just look  throughput
> in my tests,  throughput not growing when enable the parameter

Right, so it's not likely the hwcrypt parameter. I was just checking. :)


Adrian
