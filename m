Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:52497 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3KJGbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Nov 2013 01:31:04 -0500
Received: by mail-lb0-f177.google.com with SMTP id u14so2432983lbd.8
        for <linux-wireless@vger.kernel.org>; Sat, 09 Nov 2013 22:31:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzYKA1qCg=nkFL1HsXraBadDei2skBzU4eVxTZ5-e+JSMUA@mail.gmail.com>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
	<526E20EA.9090203@rempel-privat.de>
	<CAMP44s2Cvw9HF3c3Asuq+bTSD36Gw6PXOUVjAcCD+hf6KB_awg@mail.gmail.com>
	<CABPxzY+xJ7kst-sYwP8RJwMO_zkNYWKaYy=_LS7WQfuxquK24w@mail.gmail.com>
	<CAMP44s0087jYz5AiEaEzwt7GqH9ed8PWE1CmvMPr4Dqn3yE6rA@mail.gmail.com>
	<CABPxzYLwwyFCFw1pEt0v9Xw4kcue1C_RZx0RbTbMrUw=+MWvgQ@mail.gmail.com>
	<CAMP44s0svc2MRKCrZXS5ZYRZNPoomQkcKHdC2m2BGy7di+TCyA@mail.gmail.com>
	<CABPxzYL-Gzbzoc_ui+qUQ6uzoKp=Yq7yLWZvc7PoEjiH3dFczg@mail.gmail.com>
	<CAMP44s3uRF=jNn5ZHZ=QOcvuMoXxsfkxU=VOq3K02Q0qOspEdA@mail.gmail.com>
	<CABPxzYJbNjAwymwUq0pN=YyuCBGy2qz_BKafatHTWK+yH8PbkA@mail.gmail.com>
	<CAMP44s1NOS2p9pKeMLhR7616CzHeHJVJEzcF1tP6tsKfcPhSOQ@mail.gmail.com>
	<CABPxzY+RL+ikbSff3a7qb20ExxcSTx6U2xcL5CFr-BgVSOr61A@mail.gmail.com>
	<CAMP44s384vOcMc4vE82gAdVf37YUZfegmPHUSeobPO=gK6ErAw@mail.gmail.com>
	<CABPxzYLDHP5gyeTL8HR=6uJDLptaUGEnNGSFLMkxKqi-JaBVYQ@mail.gmail.com>
	<CABPxzYJTuV0vGLnhgcQcXbg_9szSm2hH7_vCeP4TOKNxZQx_Gg@mail.gmail.com>
	<CAMP44s3VRnqw0XJDZTZTym7wBD5-NnfOD56YHbE87OG=3Zan2w@mail.gmail.com>
	<CAMP44s15W7gb8rXwqum5bdHOSk=A_sadX7ksvtkG0qTOu1RREg@mail.gmail.com>
	<CABPxzYLtbs1s-_T+hk+N1hOEuCi_Yq+CGxG7Xx0hPRmiyQM0Jg@mail.gmail.com>
	<CAMP44s0h836BZ+g9-g_t78bKuV_m_xAuvPYRCHaFdJ58eTKthw@mail.gmail.com>
	<CABPxzYJsLqJbJQzr8+2GujQsbJpo922v9ouVWWPbTFL11-UV5g@mail.gmail.com>
	<CAMP44s1ZtTyfKmgy4174ukQU1dwx1Fw=AngNQ=g2Dv2wm4t2-g@mail.gmail.com>
	<CABPxzYKPpL7p0gexV3udgsWYZ_zVYxT6vrz-n-rN36D2AgBCgg@mail.gmail.com>
	<CAMP44s1vwEMRYost99JgLxvXJkFwhgnn9jnYR5RxLPDm-Qj7ug@mail.gmail.com>
	<CABPxzYKQfz2CBvHwWHXT9rSZ6He8ru1R-dP5z+wVy8o3o6L8eQ@mail.gmail.com>
	<CAMP44s2JsVdhRWvkF+jBFns93v7w5kGsP5H83V=CjZr6QynLQA@mail.gmail.com>
	<CABPxzYKA1qCg=nkFL1HsXraBadDei2skBzU4eVxTZ5-e+JSMUA@mail.gmail.com>
Date: Sun, 10 Nov 2013 08:31:01 +0200
Message-ID: <CANUX_P2+zb0-rU-0ryCnOdxjSkFcSNXJbmJ3B0HtJcnYpsrbQg@mail.gmail.com> (sfid-20131110_073125_674504_BFBC9E8B)
Subject: Re: I always need a miracle to connect with iwlwifi
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>>>>>> But we are receiving 0 beacons, waiting for more than 1 won't help.
>>>>>>>> BTW, why NEED_DTIM_BEFORE_ASSOC if the device doesn't *need* the DTIM
>>>>>>>> before the association?
>>>>>>>>
>>>>> This is not just for your case but rather on a generic note. Regarding
>>>>> the flag even i am not
>>>>> too sure but i guess some hardware need to know the DTIM to set the
>>>>> wakeup schedule
>>>>> after the association?
>>>>

Right - we need the send the beacon interval to the device *before* we
configure the device to be associated.

>>>> But not this hardware? Because everything works fine.
>>>>
>>>>>>> Oops...you just missed, Right after your print there is a check to
>>>>>>> drop frames with BAD CRC :-).
>>>>>>
>>>>>> That's why I put the print before that check. Since I don't see the
>>>>>> print, that means the check was never executed. iwlagn_rx_reply_rx()
>>>>>> was never called for the beacon frame.
>>>>>>

That won't help since the firmware will drop frames with bad CRC,
unless you are in monitor mode.

>>>>> Ok. So when we disable advertising of that flag in the driver you said things
>>>>> are working fine.
>>>>
>>>> Yes, everything works perfectly.
>>>>
>>>>> So in that scenario after the connection are you
>>>>> seeing the beacons?
>>>>
>>>> No, there are no beacons ever, at least from this AP
>>
>>> Oh ok, thats interesting. Are you not seeing any disconnects due
>>> to beacon loss triggers?
>>
>> I see some disconnects now and then, but I don't know why. Before
>> trying to tackle those problems I would like to be able to connect
>> reliably.

No wonder. If we can't receive any beacons you can expect issues....
PS will be completely broken and that is only the first on the list...

>
> Its probably the beacons loss that triggering the disconnects, so
> both the problem have the same cause. Its the beacon reception
> we need to figure it out.
>
> Adding some intel guys explicitly.
>
>>> Also can you add some debugging to the iwlagn_rx_beacon_notif
>>> (the beacon RX handler)?
>>
>> All right, I've added debugging there, but so far I see nothing.
>>
>
> Hmm...dead end this side too.
>
>>>> It seems to me all the beacon frames are dropped by the firmware
>>>> before passing them to the driver, so the driver cannot parse them and
>>>> do something sensible even though they are corrupted, the driver never
>>>> gets them.
>>>>
>>>>> Just want to understand the problem is throughout or just before association.
>>>>> If the driver itself it not getting the beacons then our debugging ends there,
>>>>> some one from intel should guide you through the FW debugging.
>>>>
>>>> Not really, part of the debugging ends there, but we can still do something.
>>>>
>>>> What is the meaning of NEED_DTIM_BEFORE_ASSOC, if the driver doesn't
>>>> *need* this? Why fail the association completely, if we don't need to?
>>>>

As I explained, the firmware needs to. This is for configuring the PS
state machine. But since you AP is completely broken, PS is likely not
to work at all anyway....
And my small experience in WiFi leads me to the conclusion that if a
driver cannot rely on the AP sending beacon, it is really in trouble.
We can cope with buggy AP, but not associate to microwaves.
Other devices will work, granted. But they can't go to sleep then, and
need to poke the AP from time to time to make sure it hasn't
disappeared.
Note that this is true regardless of the design / HW wahtever. Ok, the
Windows driver on the same device works with this "AP". Fine. But it
can't theoretically can't work well. Nor can any other WiFi device
that can't hear the beacon. Now - maybe we have an issue in the Linux
driver that mangles the beacons (PHY stuff) - that's possible. But
since you haven't sent a sniffer capture of the AP with another
device, we can't know.

>>>> Also, I realized that after rebooting the router, the beacon frames
>>>> are not corrupted any more, so it's a compound problem, yet even in
>>>> the corrupted case, the driver can work just fine, if only it didn't
>>>> *require* the DTIM unnecessarily,
>>>
>>> Yeah, that's more of design query with the problem being not able to
>>> Rx the beacons? We need to understand the reason for this flag being
>>> set by the iwlwifi driver.
>>
>> Indeed.
>>
>>>>as apparently all hardware and even
>>>> other OS'es on this hardware do.
>>>
>>> Thats the reason this flag is a _HW_ not all hardwares requrie this
>>> but intel does.
>>
>> But it doesn't, my hardware is Intel, and it works fine without it.
>>
> Yeah, so far so good. But there should be a reason why they are
> specifically advertising this flag? Also DTIM is Multicast+Powersave
> so a rare thing, we might no hit that too often.

Hmm... well... N/M.
