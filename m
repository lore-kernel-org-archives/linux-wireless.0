Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:44133 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaLDJ0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 04:26:41 -0500
Received: by mail-oi0-f49.google.com with SMTP id i138so11977401oig.36
        for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2014 01:26:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54802031.7010709@rempel-privat.de>
References: <CAD-4tLW3cvGrw3MYiLQni7OMJYGa=QJbrk_q9=9P2QuBb1EVFg@mail.gmail.com>
	<CA+55aFw6zo4rTsEEX5uQe+8zeNR87JzmM8T=wYW7jvrHZPjB8A@mail.gmail.com>
	<20141129191601.GA1234@kroah.com>
	<CAD-4tLXYVtKJMWYW6cQ9aCL6rusUx3YpWSHys4xcTRN_dJ+kOA@mail.gmail.com>
	<20141130184615.GA3122@kroah.com>
	<CAD-4tLU-3otYOTO98s359z80SSbTJbiSstAYijiU__ekOPJkOA@mail.gmail.com>
	<20141204012407.GA31191@kroah.com>
	<CAD-4tLVrOqiUX2V9_VWMBbnFT-qEsO=zQF4qejd_N2H=scb4aw@mail.gmail.com>
	<20141204043945.GA22144@kroah.com>
	<CAGRGNgXiAAcFoUJyJiC2=yi7LGAU-=6L=NZpJxNj3V4E74RxCw@mail.gmail.com>
	<20141204082348.GA1989@redhat.com>
	<54802031.7010709@rempel-privat.de>
Date: Thu, 4 Dec 2014 14:56:40 +0530
Message-ID: <CAD-4tLWoLO8=NXnzuV8eHXcW5WDeS-Wv8uTvw=uiWEdDa9HKHg@mail.gmail.com> (sfid-20141204_102650_325050_14CA71F3)
Subject: Re: Ralink 6570 / Mediatek MT7601STA (was Re: Addition of a wifi
 kernel module to the linux source tree)
From: Parth Sane <laerdevstudios@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"driverdev-devel@linuxdriverproject.org"
	<driverdev-devel@linuxdriverproject.org>,
	Larry Finger <larry.finger@lwfinger.net>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
Guys I'll be using my other account on my private domain laer.in now
onwards. Be sure to add me in your contacts. My new email is
parthsane@laer.in
-Parth

On 4 December 2014 at 14:19, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 04.12.2014 um 09:23 schrieb Stanislaw Gruszka:
>> On Thu, Dec 04, 2014 at 03:52:52PM +1100, Julian Calaby wrote:
>>> On Thu, Dec 4, 2014 at 3:39 PM, Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>>>> On Thu, Dec 04, 2014 at 07:07:58AM +0530, Parth Sane wrote:
>>>>> Hi,
>>>>> I'd say I'm midway through with c programming(part of my computer
>>>>> engineering degree course) and know a decent amount of git. So yes I'm
>>>>> comfortable writing code.
>>>>
>>>> Ok great, let's see if it's just a matter of some changes to the
>>>> existing kernel driver before we decide to add the whole huge tarball
>>>> to the staging tree as fixing it up will be a lot of work.
>>>
>>> I believe some people (CC'd) may have been working on / had an
>>> interest in writing such a driver. I'm not sure what the status of
>>> that effort is though.
>>
>> Right. Felix is working on new linux friendly driver for new Mediatek
>> chips.
>
> So far i know, Felix is working on abgn+ac (MT7662 and MT7612) devices.
> MT7601STA is (a)bgn. Are there similar regs?
>
> In mt7601 code i see parts like "if (IS_RT3290(pAd) || IS_RT65XX(pAd) ||
> IS_MT7601(pAd))".  RT3290 is supported by rt2x00.
>
> --
> Regards,
> Oleksij
>
