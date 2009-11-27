Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54795 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZK0Bhg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 20:37:36 -0500
Received: by pwi3 with SMTP id 3so730234pwi.21
        for <linux-wireless@vger.kernel.org>; Thu, 26 Nov 2009 17:37:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890911261348g32edb851obbba8e265ad22e95@mail.gmail.com>
References: <d82e647a0911260557l5cf33449pe41f8902b6889891@mail.gmail.com>
	 <69e28c910911260902p5385cd33wa0d5e00199235dd1@mail.gmail.com>
	 <43e72e890911261348g32edb851obbba8e265ad22e95@mail.gmail.com>
Date: Fri, 27 Nov 2009 09:37:41 +0800
Message-ID: <d82e647a0911261737j2bb9d07fj453e7d43a8f2e2dd@mail.gmail.com>
Subject: Re: [question] ath9k: 11n monitor mode
From: Ming Lei <tom.leiming@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Matteo Croce <matteo@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/27 Luis R. Rodriguez <lrodriguez@atheros.com>:
> 2009/11/26 Gábor Stefanik <netrolller.3d@gmail.com>:
>> I don't know exactly, but a while ago there was a discussion about how
>> to represent HT rates in Radiotap. AFAIK mac80211 refuses to forward
>> HT packets to monitor interfaces as they don't have a valid CCK or
>> OFDM rate.
>
> Matteo added a suggested field for radiotap for MCS rates:
>
> http://www.radiotap.org/suggested-fields/MCS

Oh, I see.

Is there any patch which may let mac80211 forward HT packets to
monitor interface now?
If there is, where could I find it?

thanks,

-- 
Lei Ming
