Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35551 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753112AbcLGQm1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 11:42:27 -0500
Received: by mail-oi0-f67.google.com with SMTP id v84so46343730oie.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 08:41:56 -0800 (PST)
Subject: Re: [PATCH 10/14] rtlwifi: Add BTC_TRACE_STRING to new btcoex
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
 <20161202014833.6856-11-Larry.Finger@lwfinger.net>
 <20161205213447.GJ8176@mwanda>
 <6442d5c7-f083-0e98-490b-dd18a5a4d316@lwfinger.net>
 <20161206071340.GB10292@kroah.com> <871sxkdjeh.fsf@kamboji.qca.qualcomm.com>
 <20161207133219.GM8176@mwanda>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <19d00566-0c32-0ca0-38ef-377ad85592bd@lwfinger.net> (sfid-20161207_174231_117899_DBEF64FF)
Date: Wed, 7 Dec 2016 10:41:54 -0600
MIME-Version: 1.0
In-Reply-To: <20161207133219.GM8176@mwanda>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/2016 07:32 AM, Dan Carpenter wrote:
> On Wed, Dec 07, 2016 at 02:16:06PM +0200, Kalle Valo wrote:
>> We have disccused this before, but for wireless it's not really that
>> simple. AFAIK with dyndbg you can only control the messages per line
>> (painful to enable group of messages) or per file (enables too many
>> messages). In wireless we have cases when we need to enable group of
>> messages, but not all.
>
> You can turn them on by the function or a range of lines, then disable
> the spammy lines.  With these new debug macros you can't do that so this
> is a step backwards.
>
> If I'm totally honest, I've never seen uglier macros than these.  I work
> in staging and I've spent a lot of time in ancient code but these ones
> really take the cake.

They will be coming out. The Realtek engineer and I are learning more about the 
various options to see what to use. The dynamic debugging options seem to be the 
best at the moment.

Larry
