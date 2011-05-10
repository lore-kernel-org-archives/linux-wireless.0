Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60292 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab1EJPN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 11:13:27 -0400
Received: by qyk7 with SMTP id 7so1772707qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 08:13:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DC9542C.6060508@hauke-m.de>
References: <684215.94213.qm@web161615.mail.bf1.yahoo.com>
	<4DC9542C.6060508@hauke-m.de>
Date: Tue, 10 May 2011 17:13:26 +0200
Message-ID: <BANLkTimp10vXTRkC7mBgDX97aiE+Eo_seg@mail.gmail.com> (sfid-20110510_171331_120407_6E08943F)
Subject: Re: [PATCH 3/3] compat-wireless: enable RT33XX and RT53XX support.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Walter Goldens <goldenstranger@yahoo.com>, mcgrof@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, May 10, 2011 at 5:05 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 05/10/2011 04:44 PM, Walter Goldens wrote:
>>
>>> This is based on a patch by Walter
>>> Goldens.
>>
>> Hi Hauke,
>>
>> I think RT53XX is still experimental, unlike the RT33XX. Should we enable it from config.mk now?
>>
>> Walter
>
> Hi Walter,
>
> In the description of RT53XX there is no warning that this is not
> working, like it is in the description of RT35XX. I do not have such a
> device, but the rt2x00 guys could probably help on this questing. If we
> enable it and it does not work it will not hurt people more that we do
> not activate it.
>
> @rt2x00 people: Are the RT53XX chips working with the most recent
> version of the rt2x00 driver from wireless-testing?

The following config options are all marked as unstable (they depend
on EXPERIMENTAL)
 RT2800PCI_RT35XX
 RT2800PCI_RT53XX
 RT2800USB_RT35XX
 RT2800USB_RT53XX

Since recently I have an RT53xx USB device, but I haven't tested it yet.
As far as I heard from other reports the status is the same as 35xx.

Ivo
