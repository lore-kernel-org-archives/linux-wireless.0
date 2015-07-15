Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:36498 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbbGOTrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2015 15:47:04 -0400
MIME-Version: 1.0
In-Reply-To: <55A6B287.9040808@gmx.de>
References: <55A43355.2070302@gmx.de>
	<CANUX_P3hndEGmrkUrW2=UjDXU2m=V7o01kabnS_7R-t0nQ0mTA@mail.gmail.com>
	<55A65F98.2030304@gmx.de>
	<CANUX_P20BhjPym8Mn1gf4ELMJOA26RjL3y0AVB_M6qjC5zReqQ@mail.gmail.com>
	<55A6B287.9040808@gmx.de>
Date: Wed, 15 Jul 2015 22:47:01 +0300
Message-ID: <CANUX_P095t=cUBs5yfAtMGdYCqJEejVo-PtRvH8azoszLS98qA@mail.gmail.com> (sfid-20150715_214959_592453_BCAB7C40)
Subject: Re: iwlwifi: Microcode SW error detected. Restarting 0x2000000.
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2015 at 10:20 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> On 07/15/2015 07:48 PM, Emmanuel Grumbach wrote:
>> Can you reproduce easily?
>>
> Unfortunately not, it happens sometimes gtwice a day, and then I do have 5 or more daays in a row w/o any problems.
>
>> What bandwidth are you using? 20Mhz or 40Mhz?
> 20 MHz accordingly to my Fritz!Box 7360 display.
>
Fritz!Box - oh well. We've had lots of issues with this kind of APs.

There is already an open bug:
https://bugzilla.kernel.org/show_bug.cgi?id=97291
