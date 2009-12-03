Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:34758 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbZLCOrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 09:47:05 -0500
Received: by iwn1 with SMTP id 1so920885iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 03 Dec 2009 06:47:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200912031200.56443.holgerschurig@gmail.com>
References: <200912031148.46934.holgerschurig@gmail.com> <1259837682.12843.10.camel@johannes.local>
	<200912031200.56443.holgerschurig@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 3 Dec 2009 06:46:51 -0800
Message-ID: <43e72e890912030646x458068acw814788cce20ea173@mail.gmail.com>
Subject: Re: question regarding cfg80211 monitor modes
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 3, 2009 at 3:00 AM, Holger Schurig <holgerschurig@gmail.com> wrote:
>> I'd say don't bother with the flags at all.
>
> Okay, I'll then a mask of 0x07, turning everything on. If someone
> doesn't like beacons, he can still use
>
>  tshark -R "!(wlan.fc.subtype == 8)"
>
>
>
> BTW:
> http://wireless.kernel.org/en/users/Documentation/modes#Monitor_mode
> doesn't say anything about the modes.

The modes or the flags? iw does document the flags.

  Luis
