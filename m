Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:46125 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbaIDU6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 16:58:50 -0400
Received: by mail-yk0-f173.google.com with SMTP id 20so6400466yks.4
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 13:58:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5408B698.6050606@candelatech.com>
References: <5408B698.6050606@candelatech.com>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Fri, 5 Sep 2014 00:58:29 +0400
Message-ID: <CAHNKnsSLmWOeH7i-K1yFESgSU23FwfUv8oTZF-HkW53+8Yn_qg@mail.gmail.com> (sfid-20140904_225901_226734_E6684972)
Subject: Re: I cannot disable RTS/CTS on ath9k.
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-09-04 22:59 GMT+04:00 Ben Greear <greearb@candelatech.com>:
> My setup is thus:
>
> ath9k station
> ath10k AP (RTS not enabled)
> ath9k monitor (on separate machine)
>
> I tried enabling (value 1024) and and also disabling RTS on the station.
>
> The station was forced to reconnect after setting the RTS value on
> the phy.
>
> But, we sniff RTS being sent by station regardless of the ath9k settings.
>
> I verified RTS configured as requested using 'iw phy phy0 info' and looking
> for RTS.
>
> Is there something else that might cause RTS to be sent even when station
> is not configured for RTS?
>
Rate control module can do this. About a year ago there was a
discussion of this feature of minstrel.

> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com

-- 
BR,
Sergey
