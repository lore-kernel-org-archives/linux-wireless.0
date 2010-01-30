Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:33477 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab0A3Qos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 11:44:48 -0500
Received: by fxm20 with SMTP id 20so2881694fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2010 08:44:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264868803.3546.189.camel@johannes.local>
References: <20100129122718.73a6c877@nehalam>
	 <1264866128.3546.185.camel@johannes.local>
	 <51058d551001300751r4a509e90i521c946dfe9dec4@mail.gmail.com>
	 <1264867217.3546.186.camel@johannes.local>
	 <51058d551001300814y66d1d589uae15fa50086593b8@mail.gmail.com>
	 <1264868231.3546.188.camel@johannes.local>
	 <51058d551001300822p7ab564e4jedd6faad380dabc@mail.gmail.com>
	 <1264868803.3546.189.camel@johannes.local>
Date: Sat, 30 Jan 2010 10:44:46 -0600
Message-ID: <51058d551001300844g2b0b4f67vc178627dd9cbab60@mail.gmail.com>
Subject: Re: Multiple SSID on same phy
From: Greg Oliver <oliver.greg@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 30, 2010 at 10:26 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2010-01-30 at 10:22 -0600, Greg Oliver wrote:
>
>> > I don't think I can parse that. In any case, a possible use case would
>> > for instance be a protected company network, along with an unprotected,
>> > internet-only guest network.
>>
>>
>> Hmmm, I would put the odds at that happening about 100,000:1 (if not more)
>>
>> Yes, I know it is feasible, but HIGHLY unlikely.
>
> It's not. openwrt for example has that as a default configuration. Even
> fonera does.

You're right - next time one of my immediate neighbors are installing
OpenWRT (at the same time), we may run into this...

I'm not meaning to argue, but is this a "real world" occurance..  I
was merely trying to point out that it shoul dnot be a priority.  Not
that it coule NEVER happen, because I think everyone knows that if the
planets and sun are all aligned properly, it could happen - just like
we'll all be dead in 2012 (j/k)..Anyway..  I respect everyone's
opinion here..  I just think (although it may make the mac80211 stack
better) that it is not aa forerunner for anything that needs
addressing as far as linux wireless goes...  This may make aircrack
better though as I am suspecting :)

-Greg
