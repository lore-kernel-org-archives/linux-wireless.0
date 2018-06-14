Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34615 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754629AbeFNHuu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 03:50:50 -0400
Received: by mail-wm0-f50.google.com with SMTP id l15-v6so2072548wmc.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2018 00:50:49 -0700 (PDT)
Subject: Re: [PATCH 0/4] cfg80211/mac80211: Add support to configure and
 monitor txrate threshold
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Tamizh Chelvam Raja <tamizhr@qti.qualcomm.com>,
        Tamizh chelvam <tamizhr@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
References: <1528887539-26821-1-git-send-email-tamizhr@codeaurora.org>
 <87fu1q7uq5.fsf@toke.dk>
 <9fd8762e9d2f4b93b299ab859e389b46@aphydexm01b.ap.qualcomm.com>
 <87a7ry7meo.fsf@toke.dk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B221E56.4000009@broadcom.com> (sfid-20180614_095054_583690_B90957A5)
Date: Thu, 14 Jun 2018 09:50:46 +0200
MIME-Version: 1.0
In-Reply-To: <87a7ry7meo.fsf@toke.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/13/2018 5:10 PM, Toke Høiland-Jørgensen wrote:
> Tamizh Chelvam Raja <tamizhr@qti.qualcomm.com> writes:
>
>>> This patchsets introduced new NL command and api to support
>>> configuring txrate threshold for the connected stations and api to
>>> notify userspace application upon crossing the configured txrate threshold.
>>> This will be useful for the application which requires station's
>>> current capability change information.
>>
>> What is the intended use case? Asking mostly out of curiosity :)
>
>> [Tamizh] This is to monitor txrate change for a station. By notifying
>> userspace when the txrate for a station goes out of configured
>> threshold, It can take steering decisions on the particular station.
>
> Yeah, I got that part. I was curious as to what (userspace) application
> you were planning to use this for? I.e., what kind of steering
> decisions? :)

It sounds like network initiated handover as opposed to station roaming. 
Suspect the user-space application referred to here is a proprietary 
application. At plumbers conf I attended a couple of years ago there was 
an idea to have a network management application controlling multiple 
hostapd instances for this type of functionality, but not sure if that 
project ever got of the ground.

Regards,
Arend
