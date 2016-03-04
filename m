Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:35758 "EHLO
	mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759080AbcCDUD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 15:03:26 -0500
Received: by mail-yw0-f178.google.com with SMTP id g127so53123031ywf.2
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2016 12:03:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87r3fql34s.fsf@purkki.adurom.net>
References: <1456947439-28968-1-git-send-email-arend@broadcom.com>
	<1457020529.2044.31.camel@sipsolutions.net>
	<56D8A618.4050707@broadcom.com>
	<1457082805.2333.0.camel@sipsolutions.net>
	<87r3fql34s.fsf@purkki.adurom.net>
Date: Fri, 4 Mar 2016 21:03:25 +0100
Message-ID: <CAF7Mx6rE5sYYj48iEyb8qQmQThbqSupZ4tazR=dSe7nYTKN6jw@mail.gmail.com> (sfid-20160304_210331_156020_82147A68)
Subject: Re: [PATCH V11 1/2] nl80211: add feature for BSS selection support
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arend Van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 4, 2016 at 3:38 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>
>> On Thu, 2016-03-03 at 22:01 +0100, Arend Van Spriel wrote:
>>>
>>> On 3-3-2016 16:55, Johannes Berg wrote:
>>> > On Wed, 2016-03-02 at 20:37 +0100, Arend van Spriel wrote:
>>> > > Introducing a new feature that the driver can use to
>>> > > indicate the driver/firmware supports configuration of BSS
>>> > > selection criteria upon CONNECT command. This can be useful
>>> > > when multiple BSS-es are found belonging to the same ESS,
>>> > > ie. Infra-BSS with same SSID. The criteria can then be used to
>>> > > offload selection of a preferred BSS.
>>> > >
>>> > Applied, finally :)
>>> >
>>> > I moved the wiphy supported methods check into parse_bss_select()
>>> > to
>>> > avoid the double error path in the caller, plus some editorial
>>> > changes.
>>>
>>> Do you expect Kalle to take the brcmfmac patch or can it go through
>>> your tree?
>>>
>>
>> I was expecting Kalle to apply it.
>
> Ack, you assigned it to me so it's on my queue now:
>
> https://patchwork.kernel.org/patch/8484901/

Thanks for the confirmation.

Regards,
Arend

> --
> Kalle Valo
