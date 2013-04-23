Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:60781 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3DWLRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 07:17:55 -0400
Received: by mail-lb0-f176.google.com with SMTP id y8so523151lbh.21
        for <linux-wireless@vger.kernel.org>; Tue, 23 Apr 2013 04:17:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51766C1F.5010102@broadcom.com>
References: <CAF8XF0cS0kY96ubMisvsm--UE1PHCzrFmRC0b1Wd5-d164EdNg@mail.gmail.com>
	<2075657.YTpB93Bl1M@bentobox>
	<CAF8XF0dqL_vQrGU+WYq6oa7dUt4MtN=6eGCVjBZayQqnssXS0w@mail.gmail.com>
	<51766C1F.5010102@broadcom.com>
Date: Tue, 23 Apr 2013 12:17:53 +0100
Message-ID: <CAF8XF0f0h9P9Epwy8R35cUEB34q4b+j7ZhdT8QN_t5LaA2XJ4g@mail.gmail.com> (sfid-20130423_131806_652872_0DC7EE80)
Subject: Re: How to find ESSID & signal strength
From: Kai Hendry <hendry@iki.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: Schrober <franzschrober@yahoo.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 April 2013 12:10, Arend van Spriel <arend@broadcom.com> wrote:
> this popped up earlier. Using shell scripts is a bad idea.  However, libnl
> does provide python bindings. nl80211 is a netlink interface to the linux
> wireless kernel module.

Whoa, isn't progress amazing? Gone are the days of simple file based
interfaces. Now we need libraries and python bindings ! :)

>> Oh while I'm here. Is there no traditional /proc like interface
>> proposal for wireless information? If not, why not?
> Because nl80211 is there to provide all the info.

Well that interface seems to suck. Sorry.

> If you do not mind reworking your shell script and want to stick to it than
> the answer is:
> $ iw wlanX link
> wlanX should be your wireless network interface.

I don't mind reworking my one line of shell, thanks. :-)

Now I wonder how I translate 'signal: -33 dBm' into the typical 5 bars
of wireless signal strength. Any tips?

Kind regards,
