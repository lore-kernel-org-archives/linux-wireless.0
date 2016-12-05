Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45089 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752580AbcLEVsw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 16:48:52 -0500
Date: Tue, 6 Dec 2016 00:48:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH 1/7] rtlwifi: btcoexist: Update routines for RTL8192EE
Message-ID: <20161205214823.GK8176@mwanda> (sfid-20161205_224858_881953_670350E5)
References: <20161203173207.17774-1-Larry.Finger@lwfinger.net>
 <20161203173207.17774-2-Larry.Finger@lwfinger.net>
 <20161205113832.GD8176@mwanda>
 <e4d07a23-d4d6-7ebd-7acd-69de3218a685@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e4d07a23-d4d6-7ebd-7acd-69de3218a685@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 05, 2016 at 11:17:28AM -0600, Larry Finger wrote:
> On 12/05/2016 05:38 AM, Dan Carpenter wrote:
> >On Sat, Dec 03, 2016 at 11:32:01AM -0600, Larry Finger wrote:
> >>From: Ping-Ke Shih <pkshih@realtek.com>
> >>
> >>The btcoexist routines for the RTL8192EE have been extensively rewritten.
> >>
> >
> >This patch does a million things and is totally unreviewable.  The
> >patch description doesn't say what patch does or why.  It's 5k lines
> >of diff.  What the heck???
> 
> I am caught in a bind. The BT coexistence routines are written by a
> Realtek contractor. As I cannot get the individual patches from
> Realtek, there is no chance of getting them from a 3rd party.

These patches are absolutely impenetrable.  A few years ago in SCSI we
gave a vendor a one time pass to just merge a huge patch and sync with
mainline.  We could view this in the same light, except that I think
when we moved this driver out of staging that was the one time pass.  By
now they should be proper kernel devs who can wipe their own bottoms...

We maybe should merge this and move the driver back to staging until
they can figure out how to maintain stuff?  That's a serious suggestion.
This patch is no way close to minimum quality requirements for upstream.

regards,
dan carpenter
