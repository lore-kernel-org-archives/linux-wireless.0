Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36598 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757103AbdDQRNN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Apr 2017 13:13:13 -0400
Received: by mail-oi0-f44.google.com with SMTP id r203so148646707oib.3
        for <linux-wireless@vger.kernel.org>; Mon, 17 Apr 2017 10:13:07 -0700 (PDT)
Subject: Re: [PATCH 12/13] rtlwifi: btcoex: 21a 1ant: fix some coding style
 issues
To: Joe Perches <joe@perches.com>, kvalo@codeaurora.org
References: <20170417000700.29057-1-Larry.Finger@lwfinger.net>
 <20170417000700.29057-13-Larry.Finger@lwfinger.net>
 <1492445382.8661.9.camel@perches.com>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <869a1d9b-79dc-9d5a-c4f3-efb99c1b1ff7@lwfinger.net> (sfid-20170417_191410_192760_0B3C2BEB)
Date: Mon, 17 Apr 2017 12:13:00 -0500
MIME-Version: 1.0
In-Reply-To: <1492445382.8661.9.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2017 11:09 AM, Joe Perches wrote:
> On Sun, 2017-04-16 at 19:06 -0500, Larry Finger wrote:
>> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>>
>> Fix alignment for coding style consistency.
>
> aside:
>
> Are all the btcoexist variants for this code identical?
>
> 8192e2ant.c 8723b1ant.c 8723b2ant.c 8821a1ant.c 8821a2ant.c
>
> Maybe some of these functions should be centralized.

They are not identical, but some of the functions could certainly be centralized.

The problem is that the btcoex software at Realtek is multi platform, and 
written by a group that has not been too eager to implement this kind of 
suggestion. If we were to force the issue, then the maintenance load on the 
separate Linux group at Realtek would be greatly increased. This current set of 
updates has already been delayed for at least two years while they found the 
resources to be able to adhere to the "small change" policy of Linux. For that 
reason alone, I would not be in favor of forcing the issue.

Larry
