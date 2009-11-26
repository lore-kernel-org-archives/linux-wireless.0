Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:65500 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZKZVtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 16:49:06 -0500
Received: by iwn1 with SMTP id 1so643610iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 26 Nov 2009 13:49:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c910911260902p5385cd33wa0d5e00199235dd1@mail.gmail.com>
References: <d82e647a0911260557l5cf33449pe41f8902b6889891@mail.gmail.com>
	<69e28c910911260902p5385cd33wa0d5e00199235dd1@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 26 Nov 2009 13:48:51 -0800
Message-ID: <43e72e890911261348g32edb851obbba8e265ad22e95@mail.gmail.com>
Subject: Re: [question] ath9k: 11n monitor mode
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Ming Lei <tom.leiming@gmail.com>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, Matteo Croce <matteo@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/26 Gábor Stefanik <netrolller.3d@gmail.com>:
> I don't know exactly, but a while ago there was a discussion about how
> to represent HT rates in Radiotap. AFAIK mac80211 refuses to forward
> HT packets to monitor interfaces as they don't have a valid CCK or
> OFDM rate.

Matteo added a suggested field for radiotap for MCS rates:

http://www.radiotap.org/suggested-fields/MCS

If approved it could mean then parsing MCS rates.

  Luis
