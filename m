Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20486 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbcLFTiJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Dec 2016 14:38:09 -0500
Date: Tue, 6 Dec 2016 22:37:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, devel@driverdev.osuosl.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/14] rtlwifi: Add BTC_TRACE_STRING to new btcoex
Message-ID: <20161206193746.GJ8244@mwanda> (sfid-20161206_203812_802095_B28ACDBF)
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
 <20161202014833.6856-11-Larry.Finger@lwfinger.net>
 <20161205213447.GJ8176@mwanda>
 <6442d5c7-f083-0e98-490b-dd18a5a4d316@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6442d5c7-f083-0e98-490b-dd18a5a4d316@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 05, 2016 at 04:34:08PM -0600, Larry Finger wrote:
> Can you point me to a driver with a better way to conditionally dump
> a debugging string to the logs?

People should look at using ftrace and kprobes.  They really are very
powerful and useful.

regards,
dan carpenter
