Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29037 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbcLGNdn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 08:33:43 -0500
Date: Wed, 7 Dec 2016 16:32:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 10/14] rtlwifi: Add BTC_TRACE_STRING to new btcoex
Message-ID: <20161207133219.GM8176@mwanda> (sfid-20161207_143347_917270_4B1EFC55)
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
 <20161202014833.6856-11-Larry.Finger@lwfinger.net>
 <20161205213447.GJ8176@mwanda>
 <6442d5c7-f083-0e98-490b-dd18a5a4d316@lwfinger.net>
 <20161206071340.GB10292@kroah.com>
 <871sxkdjeh.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <871sxkdjeh.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 07, 2016 at 02:16:06PM +0200, Kalle Valo wrote:
> We have disccused this before, but for wireless it's not really that
> simple. AFAIK with dyndbg you can only control the messages per line
> (painful to enable group of messages) or per file (enables too many
> messages). In wireless we have cases when we need to enable group of
> messages, but not all.

You can turn them on by the function or a range of lines, then disable
the spammy lines.  With these new debug macros you can't do that so this
is a step backwards.

If I'm totally honest, I've never seen uglier macros than these.  I work
in staging and I've spent a lot of time in ancient code but these ones
really take the cake.

regards,
dan carpenter
