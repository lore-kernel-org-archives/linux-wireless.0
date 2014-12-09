Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:48478 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaLISRS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2014 13:17:18 -0500
Message-ID: <54873CAC.5040604@broadcom.com> (sfid-20141209_191722_247887_6D5CEC5B)
Date: Tue, 9 Dec 2014 19:17:16 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Aaron Dunkel <customdev@twistedmindsinc.com>
CC: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom Wireless Chipsets and Their Usefulness
References: <CAJQQpXSofXM=_BF_Of7++ZQE9dgX=-yNUhZWvsU-G3d+Ko5nNw@mail.gmail.com>
In-Reply-To: <CAJQQpXSofXM=_BF_Of7++ZQE9dgX=-yNUhZWvsU-G3d+Ko5nNw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/08/14 21:22, Aaron Dunkel wrote:
> Dear Arend,
>
> I first bought a Broadcom wireless platform in 2010. As part of the open
> source community I like to deploy Linux based solutions and use wireless
> platforms as general purpose development tools. As such I develop on
> Qualcomm, Realtek, Ralink, Atmel, and several other varieties of
> hardware. Sadly, I have relegated a vast majority of my Broadcom
> hardware to the back of my development space for a simple reason:
>
> Lack of drivers, code, and support from Broadcom.
>
> The only platform that I use from Broadcom's portfolio is the Raspberry
> Pi (BCM2803). The only two reasons I utilize it are for the specs of the
> hardware and the fact that I can interface other networking solutions to
> it easily without having to do tedious BGA rework or using a USB based
> solution from another company as a crutch for wireless connectivity.
>
> My development plans thus far involve no business with Broadcom based on
> the effort and cost needed to develop a functional solution. One
> application involving 802.11s on your hardware would sta kond to

My reading skill are failing me. What does "sta kond" mean?

> revolutionize the IoT, interoperability between three generations of
> hardware, increase the demand for your hardware, and allow for its reuse
> after the useful development lifecycle. The simple interconnectivity
> provided by a mesh network is astounding. However such functionality is
> absent because there is no software; in essence driver support.
>
> It is a shame that I can pull an AR9344 based platform from Qualcomm off
> the shelf and form a fully functional 802.11s node in 5 minutes using
> uploaded firmware for under $20. Yet I have had the most advanced of
> Broadcom's N, AC, and draft N hardware on the shelf for up to 4 years
> yet never been able to utilize it fully.
>
> In summary why is it that it takes four of the best years of my
> programming and hardware development career, the collective bleating of
> the entire open source community, and the efforts of Eben Upton to get a
> minimal amount of functional code? Broadcom's hardware seems to have the
> best performance in the industry with the least functionality exposed to
> the end user (developer).
>
> Let us hope that the rest of the industry does not share the same
> sentiment that I do for the sake of Broadcom's future.

I am not sure what message you are trying to bring across here. It has 
taken four of my own years of programming and some of my colleagues to 
provide the open source community with drivers for Broadcom's wifi 
hardware. Are you saying this effort was a waste? Or is this just a 
subtle way to ask for 11s support? The end-user of Broadcom's hardware 
are generally *not* developers. Our customers are OEMs and they 
intentionally ship their stuff with only needed functionality exposed 
just because the end-users are not developers.

Regards,
Arend
