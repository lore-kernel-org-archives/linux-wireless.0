Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48806 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752603AbcKONey (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 08:34:54 -0500
Message-ID: <1479216891.12007.29.camel@sipsolutions.net> (sfid-20161115_143457_499622_E8812C47)
Subject: Re: [PATCH RESEND v2] cfg80211: add bitrate for 20MHz MCS 9
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <twp@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 15 Nov 2016 14:34:51 +0100
In-Reply-To: <20161031182840.5984-1-twp@qca.qualcomm.com> (sfid-20161031_193145_758136_3E14680B)
References: <20161031182840.5984-1-twp@qca.qualcomm.com>
         (sfid-20161031_193145_758136_3E14680B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-31 at 11:28 -0700, Thomas Pedersen wrote:
> Some drivers (ath10k) report MCS 9 @ 20MHz, which
> technically isn't defined. To get more meaningful value
> than 0 out of this however, just extrapolate a bitrate
> from ratio of MCS 7 and 9 in channels where it is allowed.
> 
applied.

johannes
