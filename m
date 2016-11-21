Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34658 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752865AbcKUMpU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 07:45:20 -0500
Message-ID: <1479732315.8662.19.camel@sipsolutions.net> (sfid-20161121_134523_568564_7900E547)
Subject: Re: [PATCH V2] cfg80211: get rid of name indirection trick for
 ieee80211_get_channel()
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 21 Nov 2016 13:45:15 +0100
In-Reply-To: <1479386933-17834-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479386933-17834-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-11-17 at 12:48 +0000, Arend van Spriel wrote:
> The comment on the name indirection suggested an issue but turned out
> to be untrue. Digging in older kernel version showed issue with
> ipw2x00
> but that is no longer true so get rid on the name indirection.
> 
Applied, thanks.

johannes
