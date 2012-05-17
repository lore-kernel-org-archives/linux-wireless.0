Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:35109 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753698Ab2EQIZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 04:25:55 -0400
Received: by obcni5 with SMTP id ni5so2758544obc.41
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 01:25:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANJm+iDif1+KREB=CJ_wYbo+Hzxo=nJL6fUxbBTQ5_C8Tz0E9Q@mail.gmail.com>
References: <1336479518-23006-1-git-send-email-yoni.divinsky@ti.com>
	<1336485961.4320.1.camel@jlt3.sipsolutions.net>
	<CANJm+iAoVkPOO61ufrM3mxzsURFZzuNcMm9N6Y=3xUbSCaC1+w@mail.gmail.com>
	<1337072920.4546.0.camel@jlt3.sipsolutions.net>
	<CANJm+iDif1+KREB=CJ_wYbo+Hzxo=nJL6fUxbBTQ5_C8Tz0E9Q@mail.gmail.com>
Date: Thu, 17 May 2012 11:25:53 +0300
Message-ID: <CANJm+iDU1ahy3B9u6nn=0E4d0Pge+OubaNE9bPaE1EXYGahOUA@mail.gmail.com> (sfid-20120517_102602_388724_D25C1F1E)
Subject: Fwd: [PATCH] mac80211: add op to configure default key id to driver
From: "Divinsky, Yonatan" <yoni.divinsky@ti.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---------- Forwarded message ----------
From: Divinsky, Yonatan <yoni.divinsky@ti.com>
Date: Tue, May 15, 2012 at 1:59 PM
Subject: Re: [PATCH] mac80211: add op to configure default key id to driver
To: Johannes Berg <johannes@sipsolutions.net>


On Tue, May 15, 2012 at 12:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-05-15 at 11:46 +0300, Divinsky, Yonatan wrote:
>> On Tue, May 8, 2012 at 5:06 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Tue, 2012-05-08 at 15:18 +0300, Yoni Divinsky wrote:
>> >> When hw_accel is enabled and encryption type is set to WEP,
>> >> the driver should get the default key index from mac80211.
>> >
>> > Well, why?
>> >
>> If the WEP encryption is done by the HW, then then low level driver
>> needs to know the defualt key index in
>> case there is more than one WEP key configured.
>
> I don't see why, for every packet mac80211 tells you what key to use.

If the HW supports auto ARP responses, then it will need to have the correct
key id in order to encrypt the ARP response.

>
> johannes
>
