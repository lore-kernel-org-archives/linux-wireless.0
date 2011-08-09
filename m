Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45123 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1HIDCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 23:02:16 -0400
Received: by yie30 with SMTP id 30so1304066yie.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 20:02:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH-LUqry4TKAvnojAo39QfT-Wy_BN94SYJEiCCRX4hrb=RcfwQ@mail.gmail.com>
References: <CAH-LUqry4TKAvnojAo39QfT-Wy_BN94SYJEiCCRX4hrb=RcfwQ@mail.gmail.com>
Date: Tue, 9 Aug 2011 11:02:15 +0800
Message-ID: <CAJ-Vmo=SED0RLmQot2yAeAmv53Yitn+RV31tf2zWOmBHXzq_0w@mail.gmail.com> (sfid-20110809_050218_277231_4634464A)
Subject: Re: AR9285 Wireless 80211n mode get only 25Mbit with Linux 2.6.38.8
 and compat-wireless-2.6.38.2-2
From: Adrian Chadd <adrian@freebsd.org>
To: Dane Shih <daneshih1981@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 August 2011 11:00, Dane Shih <daneshih1981@gmail.com> wrote:

> /etc/modprobe.d/ath9.conf
> options ath9k nohwcrypt=1
> modprobe -v ath9k

Out of curiousity, why are you using nohwcrypt=1 ?


adrian
