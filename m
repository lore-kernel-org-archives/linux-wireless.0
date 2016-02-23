Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35335 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbcBWKtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:49:09 -0500
Received: by mail-wm0-f65.google.com with SMTP id g62so21197746wme.2
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2016 02:49:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456224168.2041.21.camel@sipsolutions.net>
References: <1455878585-5525-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1455878585-5525-3-git-send-email-lorenzo.bianconi83@gmail.com>
	<1456222250.2041.8.camel@sipsolutions.net>
	<CAA2SeNLB+oL00Mx1BCccA4eOx6nghLUofruPSepW70VWRS8EQQ@mail.gmail.com>
	<1456224168.2041.21.camel@sipsolutions.net>
Date: Tue, 23 Feb 2016 11:49:08 +0100
Message-ID: <CAA2SeN+dN8dMs-RjmdRUzTZSVjerwtowpqJ54ZUcK14z7vu7Cg@mail.gmail.com> (sfid-20160223_114914_545042_F8EBB0CA)
Subject: Re: [PATCH v2 2/2] mac80211: parse VHT info in injected frames
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, 2016-02-23 at 11:29 +0100, Lorenzo Bianconi wrote:
>> I used the previous commit scheme (mac80211: Parse legacy and HT rate
>> in injected frames).
>
> Oh, I merged something similar there? My mistake.
>

No worries :)

>> I will rewrite the documentation. Should I send v3 or a different
>> patch?
>>
>
> Please resend, I didn't apply this. Perhaps you can (separately?) fix
> the HT documentation as well then?
>

Should I resend just 2/2 or the first one as well? Ok, I will fix the
documentation in another patch

> Thanks,
> johannes

Regards,
Lorenzo



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
