Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58971 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760862AbZKZRDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 12:03:12 -0500
Received: by fxm5 with SMTP id 5so916108fxm.28
        for <linux-wireless@vger.kernel.org>; Thu, 26 Nov 2009 09:03:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d82e647a0911260557l5cf33449pe41f8902b6889891@mail.gmail.com>
References: <d82e647a0911260557l5cf33449pe41f8902b6889891@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 26 Nov 2009 18:02:57 +0100
Message-ID: <69e28c910911260902p5385cd33wa0d5e00199235dd1@mail.gmail.com>
Subject: Re: [question] ath9k: 11n monitor mode
To: Ming Lei <tom.leiming@gmail.com>
Cc: lrodriguez@atheros.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't know exactly, but a while ago there was a discussion about how
to represent HT rates in Radiotap. AFAIK mac80211 refuses to forward
HT packets to monitor interfaces as they don't have a valid CCK or
OFDM rate.

On Thu, Nov 26, 2009 at 2:57 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> Hi Luis,
>
> I find the wireshark can only capture 11b/g packets but any 11n packets over
> my ar9283 card, and I can confirm I have set HT40+ to make it work in 11n mode.
>
> wireshark : 1.2.2
> kernel       : 2.6.32-rc6
>
> I don't know what is wrong with it, and could ath9k work well in monitor
> mode of 11n?  or other reason?
>
> Look forward to your reply.
>
> Thanks,
>
> --
> Lei Ming
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
