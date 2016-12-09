Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.mailbox.org ([80.241.60.212]:54273 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751865AbcLJACU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Dec 2016 19:02:20 -0500
Subject: Re: [PATCH 10/14] rtlwifi: Add BTC_TRACE_STRING to new btcoex
To: Kalle Valo <kvalo@codeaurora.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
 <20161202014833.6856-11-Larry.Finger@lwfinger.net>
 <20161205213447.GJ8176@mwanda>
 <6442d5c7-f083-0e98-490b-dd18a5a4d316@lwfinger.net>
 <20161206071340.GB10292@kroah.com> <871sxkdjeh.fsf@kamboji.qca.qualcomm.com>
 <20161207133219.GM8176@mwanda> <87y3zqbq8h.fsf@kamboji.qca.qualcomm.com>
 <20161208115049.GR8176@mwanda> <20161208115450.GK8244@mwanda>
 <87vaut32qd.fsf@kamboji.qca.qualcomm.com>
Cc: devel@driverdev.osuosl.org, Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
From: =?UTF-8?Q?Markus_B=c3=b6hme?= <markus.boehme@mailbox.org>
Message-ID: <77555ffb-de05-2837-2e13-aaf4ec710fc3@mailbox.org> (sfid-20161210_010224_058873_AFDFD167)
Date: Sat, 10 Dec 2016 00:56:17 +0100
MIME-Version: 1.0
In-Reply-To: <87vaut32qd.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2016 09:50 AM, Kalle Valo wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
> 
>> On Thu, Dec 08, 2016 at 02:50:49PM +0300, Dan Carpenter wrote:
>>> On Thu, Dec 08, 2016 at 01:43:42PM +0200, Kalle Valo wrote:
>>>> But it would make me very happy if someone would add a similar grouping
>>>> functionality to dyndbg to make it easy to enable a set of debug
>>>> messages in a driver.
>>>
>>> Thats seems like a reasonable thing as well.
>>
>> I actually like the ath code...  We could easily change it to be more
>> generic and make it a top level function for everyone to use.
> 
> That would be great. And maybe add a sysfs file with a description
> different levels, like module parameters have. Too bad that I can't work
> on that, too much stuff on my plate right now.
> 

In this case I would like to step in and try to implement grouping of
messages in the dynamic debug code. This seems to be an interesting
learning opportunity.

Regards,
Markus
