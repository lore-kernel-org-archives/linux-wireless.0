Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:60999 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab3DXKVM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 06:21:12 -0400
From: Kalle Valo <kvalo@adurom.com>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Kai Hendry" <hendry@iki.fi>, Schrober <franzschrober@yahoo.de>,
	linux-wireless@vger.kernel.org
Subject: Re: How to find ESSID & signal strength
References: <CAF8XF0cS0kY96ubMisvsm--UE1PHCzrFmRC0b1Wd5-d164EdNg@mail.gmail.com>
	<2075657.YTpB93Bl1M@bentobox>
	<CAF8XF0dqL_vQrGU+WYq6oa7dUt4MtN=6eGCVjBZayQqnssXS0w@mail.gmail.com>
	<51766C1F.5010102@broadcom.com>
Date: Wed, 24 Apr 2013 13:21:01 +0300
In-Reply-To: <51766C1F.5010102@broadcom.com> (Arend van Spriel's message of
	"Tue, 23 Apr 2013 13:10:23 +0200")
Message-ID: <87ip3c5iwi.fsf@purkki.adurom.net> (sfid-20130424_122118_008545_0C115C76)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Arend van Spriel" <arend@broadcom.com> writes:

> On 04/23/2013 12:14 PM, Kai Hendry wrote:
>> Hi there Schrober,
>>
>> On 23 April 2013 11:00, Schrober <franzschrober@yahoo.de> wrote:
>>> "Do NOT screenscrape this tool, we don't consider its output stable."
>>> Use nl80211
>>
>> Could you give me a code sample how you would use this "nl80211"
>> thing, from shell?
>
> this popped up earlier. Using shell scripts is a bad idea.  However,
> libnl does provide python bindings. nl80211 is a netlink interface to
> the linux wireless kernel module.

I think someone should fork iw which would only provide tabular output
for shell scripts. Shouldn't be too hard, the most difficult part is to
make sure that the output format is extensible when adding new features.

-- 
Kalle Valo
