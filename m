Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19026 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752986AbcLHLzQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Dec 2016 06:55:16 -0500
Date: Thu, 8 Dec 2016 14:54:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: devel@driverdev.osuosl.org, Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 10/14] rtlwifi: Add BTC_TRACE_STRING to new btcoex
Message-ID: <20161208115450.GK8244@mwanda> (sfid-20161208_125520_125479_029D503D)
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
 <20161202014833.6856-11-Larry.Finger@lwfinger.net>
 <20161205213447.GJ8176@mwanda>
 <6442d5c7-f083-0e98-490b-dd18a5a4d316@lwfinger.net>
 <20161206071340.GB10292@kroah.com>
 <871sxkdjeh.fsf@kamboji.qca.qualcomm.com>
 <20161207133219.GM8176@mwanda>
 <87y3zqbq8h.fsf@kamboji.qca.qualcomm.com>
 <20161208115049.GR8176@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161208115049.GR8176@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 08, 2016 at 02:50:49PM +0300, Dan Carpenter wrote:
> On Thu, Dec 08, 2016 at 01:43:42PM +0200, Kalle Valo wrote:
> > But it would make me very happy if someone would add a similar grouping
> > functionality to dyndbg to make it easy to enable a set of debug
> > messages in a driver.
> 
> Thats seems like a reasonable thing as well.

I actually like the ath code...  We could easily change it to be more
generic and make it a top level function for everyone to use.

regards,
dan carpenter
