Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36183 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3KINKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Nov 2013 08:10:52 -0500
Received: by mail-wg0-f45.google.com with SMTP id x13so1943767wgg.0
        for <linux-wireless@vger.kernel.org>; Sat, 09 Nov 2013 05:10:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMP44s1ZtTyfKmgy4174ukQU1dwx1Fw=AngNQ=g2Dv2wm4t2-g@mail.gmail.com>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
 <526E20EA.9090203@rempel-privat.de> <CAMP44s2Cvw9HF3c3Asuq+bTSD36Gw6PXOUVjAcCD+hf6KB_awg@mail.gmail.com>
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
 <CABPxzYJsLqJbJQzr8+2GujQsbJpo922v9ouVWWPbTFL11-UV5g@mail.gmail.com> <CAMP44s1ZtTyfKmgy4174ukQU1dwx1Fw=AngNQ=g2Dv2wm4t2-g@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sat, 9 Nov 2013 18:40:30 +0530
Message-ID: <CABPxzYKPpL7p0gexV3udgsWYZ_zVYxT6vrz-n-rN36D2AgBCgg@mail.gmail.com> (sfid-20131109_141112_346796_577C8F07)
Subject: Re: I always need a miracle to connect with iwlwifi
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>, ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 9, 2013 at 2:22 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Fri, Nov 8, 2013 at 2:30 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>> On Fri, Nov 8, 2013 at 7:48 PM, Felipe Contreras
>> <felipe.contreras@gmail.com> wrote:
>>> On Fri, Nov 8, 2013 at 8:06 AM, Krishna Chaitanya
>>> <chaitanya.mgit@gmail.com> wrote:
>>>> On Fri, Nov 8, 2013 at 6:44 PM, Felipe Contreras
>>>> <felipe.contreras@gmail.com> wrote:
>>>>> On Fri, Nov 8, 2013 at 2:35 AM, Felipe Contreras
>>>>> <felipe.contreras@gmail.com> wrote:
>>>>>> On Sat, Nov 2, 2013 at 2:05 PM, Krishna Chaitanya
>>>>>> <chaitanya.mgit@gmail.com> wrote:
>>>>>>
>>>>>>> Also one more thing you said N900 uses mac80211 and it has no issues, but as
>>>>>>> its a embedded device it might running an older kernel where the
>>>>>>> handling might be
>>>>>>> different, so we need to try with the same kernel you are facing an
>>>>>>> issue with the
>>>>>>> a driver which advertises IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC.
>>>>>>
>>>>>> Yes it was running an older kernel, but I just compiled v3.12 and ran
>>>>>> it on the N900, and still everything works fine.
>>>>>>
>>>>>>> (or) if you a have a compilation environment try commenting the advertisement of
>>>>>>> IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC in the iwlwifi DVM driver and
>>>>>>> try to reproduce the issue.
>>>>>>
>>>>>> After commenting that flag everything works fine :)
>>>>
>>>> Oh, great. That was just to corner the problem, that means we are not getting
>>>> the required beacon  before the association, but we only wait for 1 beacon here
>>>> may be we to wait for some number of beacons before giving up the association??
>>>>
>>>> Johannes??
>>>
>>> But we are receiving 0 beacons, waiting for more than 1 won't help.
>>> BTW, why NEED_DTIM_BEFORE_ASSOC if the device doesn't *need* the DTIM
>>> before the association?
>>>
This is not just for your case but rather on a generic note. Regarding
the flag even i am not
too sure but i guess some hardware need to know the DTIM to set the
wakeup schedule
after the association?

>>>>>> What are the next steps?
>>>>>
>>>>> I tried to add some debugging to see what's going on, and indeed the
>>>>> beacon packets are lost, I added debugging as low in the chain as I
>>>>> could (iwlagn_rx_reply_rx()), and I don't see them there. However,
>>>>> when I enable the monitor mode, I see them. What's going on?
>>>>
>>>> In the captures you shared all the beacons are malformed, so
>>>> probably they failed the CRC check. iwlwifi drops all the CRC failed
>>>> packets. (doth MVM and DVM)
>>>
>>> Before iwlagn_rx_reply_rx()?
>>>
>>>> Not sure how you are receiving the beacons in the monitor mode.
>>>
>>> I don't know what kismet does, but I can see my debugging is printing them.
>>>
>>>> BTW did you tried capturing the beacons in other devices and see if they
>>>> are really malformed, or is it just iwlwifi interpreting them wrongly.?
>>>
>>> I haven't managed to do that yet.
>>>
>>> This is what I'm doing:
>>>
>>> --- a/drivers/net/wireless/iwlwifi/dvm/rx.c
>>> +++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
>>> @@ -919,6 +919,11 @@ static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
>>>         ampdu_status = iwlagn_translate_rx_status(priv,
>>>                                                   le32_to_cpu(rx_pkt_status));
>>>
>>> +       if (ieee80211_is_beacon(header->frame_control)) {
>>> +               print_hex_dump(KERN_INFO, "iwlwifi: dump: ", DUMP_PREFIX_OFFSET,
>>> +                               16, 1, header, len, true);
>>> +       }
>>> +
>>>         if ((unlikely(phy_res->cfg_phy_cnt > 20))) {
>>>                 IWL_DEBUG_DROP(priv, "dsp size out of range [0,20]: %d\n",
>>>                                 phy_res->cfg_phy_cnt);
>>>
>> Oops...you just missed, Right after your print there is a check to
>> drop frames with BAD CRC :-).
>
> That's why I put the print before that check. Since I don't see the
> print, that means the check was never executed. iwlagn_rx_reply_rx()
> was never called for the beacon frame.
>
Ok. So when we disable advertising of that flag in the driver you said things
are working fine. So in that scenario after the connection are you
seeing the beacons?

Just want to understand the problem is throughout or just before association.
If the driver itself it not getting the beacons then our debugging ends there,
some one from intel should guide you through the FW debugging.
