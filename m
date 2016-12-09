Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51828 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753113AbcLIIs4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Dec 2016 03:48:56 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 10/14] rtlwifi: Add BTC_TRACE_STRING to new btcoex
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
        <20161202014833.6856-11-Larry.Finger@lwfinger.net>
        <20161205213447.GJ8176@mwanda>
        <6442d5c7-f083-0e98-490b-dd18a5a4d316@lwfinger.net>
        <20161206071340.GB10292@kroah.com>
        <871sxkdjeh.fsf@kamboji.qca.qualcomm.com>
        <20161207133219.GM8176@mwanda>
        <87y3zqbq8h.fsf@kamboji.qca.qualcomm.com>
        <20161208115049.GR8176@mwanda>
Date: Fri, 09 Dec 2016 10:48:47 +0200
In-Reply-To: <20161208115049.GR8176@mwanda> (Dan Carpenter's message of "Thu,
        8 Dec 2016 14:50:49 +0300")
Message-ID: <87zik532ts.fsf@kamboji.qca.qualcomm.com> (sfid-20161209_094940_021521_9D2ECD26)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> I don't have a problem with the ath debug printks.  Larry asked me for
> examples of better debug functions and the ath code is an example.
> Literally, any existing debug functions are better than the
> BTC_TRACE_STRING() stuff.

Sure, I agree with that. My point was just that sometimes it's ok to
have own logging wrappers and there's no hard rule for this.

-- 
Kalle Valo
