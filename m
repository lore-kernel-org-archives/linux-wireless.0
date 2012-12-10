Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43635 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab2LJQYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 11:24:15 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so1602806qcr.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 08:24:15 -0800 (PST)
Message-ID: <50C60CAB.4080400@lwfinger.net> (sfid-20121210_172419_786204_FB3A2D55)
Date: Mon, 10 Dec 2012 10:24:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: dmarkh@cfl.rr.com, markh@compro.net, linux-wireless@vger.kernel.org
Subject: Re: rtl8192cu problem - Re: Wireless network problem with Access
 Point selection using ifup
References: <50C0A743.3000305@compro.net>      (sfid-20121206_152423_356618_ADE5D3BC) <1354806200.18211.1.camel@jlt4.sipsolutions.net>     <50C1C103.1000803@cfl.rr.com> <50C256A9.7010008@compro.net>    <1354913688.9124.2.camel@jlt4.sipsolutions.net>    <50C25A4B.8030302@compro.net> <50C5B65F.4040104@cfl.rr.com>   <1355135199.9857.11.camel@jlt4.sipsolutions.net>   <50C5C321.1090501@cfl.rr.com>  <1355138959.9857.13.camel@jlt4.sipsolutions.net>  <50C5CEF4.1070907@cfl.rr.com> <1355143613.9857.20.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355143613.9857.20.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2012 06:46 AM, Johannes Berg wrote:
> On Mon, 2012-12-10 at 07:00 -0500, Mark Hounschell wrote:
>
>> Should I file and bug report and/or contact the author?
>
> Larry, the issue seems to be that rtl8192cu doesn't scan after having
> disconnected at least once, and maybe doesn't report any/good signal
> strength values.

The problem is likely that rtl8192cu goes mute after a disconnect. I'm not sure 
if it happens only with WPA/WPA2 or if all encryption methods are affected. I 
have not yet found the problem, but this and other reports have increased the 
priority.

Larry


