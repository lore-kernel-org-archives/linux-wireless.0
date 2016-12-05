Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34461 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbcLERRb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 12:17:31 -0500
Received: by mail-oi0-f67.google.com with SMTP id m75so37563021oig.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 09:17:30 -0800 (PST)
Subject: Re: [PATCH 1/7] rtlwifi: btcoexist: Update routines for RTL8192EE
To: Dan Carpenter <dan.carpenter@oracle.com>
References: <20161203173207.17774-1-Larry.Finger@lwfinger.net>
 <20161203173207.17774-2-Larry.Finger@lwfinger.net>
 <20161205113832.GD8176@mwanda>
Cc: kvalo@codeaurora.org, devel@driverdev.osuosl.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <e4d07a23-d4d6-7ebd-7acd-69de3218a685@lwfinger.net> (sfid-20161205_181736_267485_4B7EB862)
Date: Mon, 5 Dec 2016 11:17:28 -0600
MIME-Version: 1.0
In-Reply-To: <20161205113832.GD8176@mwanda>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2016 05:38 AM, Dan Carpenter wrote:
> On Sat, Dec 03, 2016 at 11:32:01AM -0600, Larry Finger wrote:
>> From: Ping-Ke Shih <pkshih@realtek.com>
>>
>> The btcoexist routines for the RTL8192EE have been extensively rewritten.
>>
>
> This patch does a million things and is totally unreviewable.  The
> patch description doesn't say what patch does or why.  It's 5k lines
> of diff.  What the heck???

I am caught in a bind. The BT coexistence routines are written by a Realtek 
contractor. As I cannot get the individual patches from Realtek, there is no 
chance of getting them from a 3rd party.

Larry
