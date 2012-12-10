Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.compro.net ([12.186.155.4]:62666 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab2LJRic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 12:38:32 -0500
Message-ID: <50C61E16.3010404@compro.net> (sfid-20121210_183835_610838_E23CB623)
Date: Mon, 10 Dec 2012 12:38:30 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Johannes Berg <johannes@sipsolutions.net>, dmarkh@cfl.rr.com,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192cu problem - Re: Wireless network problem with Access
 Point selection using ifup
References: <50C0A743.3000305@compro.net>      (sfid-20121206_152423_356618_ADE5D3BC) <1354806200.18211.1.camel@jlt4.sipsolutions.net>     <50C1C103.1000803@cfl.rr.com> <50C256A9.7010008@compro.net>    <1354913688.9124.2.camel@jlt4.sipsolutions.net>    <50C25A4B.8030302@compro.net> <50C5B65F.4040104@cfl.rr.com>   <1355135199.9857.11.camel@jlt4.sipsolutions.net>   <50C5C321.1090501@cfl.rr.com>  <1355138959.9857.13.camel@jlt4.sipsolutions.net>  <50C5CEF4.1070907@cfl.rr.com> <1355143613.9857.20.camel@jlt4.sipsolutions.net> <50C60CAB.4080400@lwfinger.net>
In-Reply-To: <50C60CAB.4080400@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2012 11:24 AM, Larry Finger wrote:
> On 12/10/2012 06:46 AM, Johannes Berg wrote:
>> On Mon, 2012-12-10 at 07:00 -0500, Mark Hounschell wrote:
>>
>>> Should I file and bug report and/or contact the author?
>>
>> Larry, the issue seems to be that rtl8192cu doesn't scan after having
>> disconnected at least once, and maybe doesn't report any/good signal
>> strength values.
>
> The problem is likely that rtl8192cu goes mute after a disconnect. I'm
> not sure if it happens only with WPA/WPA2 or if all encryption methods
> are affected. I have not yet found the problem, but this and other
> reports have increased the priority.
>

FYI,

If you look at the logs for the instance when the furthest away AP was 
selected (info-furthest-away), At least I, see no disconnections at all. 
It selected the furthest AP yet was unusable. Yet no disconnects and 
iwconfig showed good.

Mark
