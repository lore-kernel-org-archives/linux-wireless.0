Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1540 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab3DWLLs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 07:11:48 -0400
Message-ID: <51766C1F.5010102@broadcom.com> (sfid-20130423_131151_558040_E44017D3)
Date: Tue, 23 Apr 2013 13:10:23 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Kai Hendry" <hendry@iki.fi>
cc: Schrober <franzschrober@yahoo.de>, linux-wireless@vger.kernel.org
Subject: Re: How to find ESSID & signal strength
References: <CAF8XF0cS0kY96ubMisvsm--UE1PHCzrFmRC0b1Wd5-d164EdNg@mail.gmail.com>
 <2075657.YTpB93Bl1M@bentobox>
 <CAF8XF0dqL_vQrGU+WYq6oa7dUt4MtN=6eGCVjBZayQqnssXS0w@mail.gmail.com>
In-Reply-To: <CAF8XF0dqL_vQrGU+WYq6oa7dUt4MtN=6eGCVjBZayQqnssXS0w@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/23/2013 12:14 PM, Kai Hendry wrote:
> Hi there Schrober,
>
> On 23 April 2013 11:00, Schrober <franzschrober@yahoo.de> wrote:
>> "Do NOT screenscrape this tool, we don't consider its output stable."
>> Use nl80211
>
> Could you give me a code sample how you would use this "nl80211"
> thing, from shell?

this popped up earlier. Using shell scripts is a bad idea.  However, 
libnl does provide python bindings. nl80211 is a netlink interface to 
the linux wireless kernel module.

>
> Oh while I'm here. Is there no traditional /proc like interface
> proposal for wireless information? If not, why not?

Because nl80211 is there to provide all the info.

If you do not mind reworking your shell script and want to stick to it 
than the answer is:

$ iw wlanX link

wlanX should be your wireless network interface.

Regards,
Arend

