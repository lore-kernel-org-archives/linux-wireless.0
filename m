Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:57927 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbbAZVPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 16:15:32 -0500
Date: Mon, 26 Jan 2015 23:04:48 +0200
From: Vadim Kochan <vadim4j@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"backports@vger.kernel.org" <backports@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: cfg80211: Unknown symbol get_net_ns_by_fd (err 0)
Message-ID: <20150126210448.GA987@angus-think.lan> (sfid-20150126_221536_598581_14D3C83E)
References: <54C6A717.5050804@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54C6A717.5050804@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 26, 2015 at 09:44:07PM +0100, Arend van Spriel wrote:
> Hi Hauke,
> 
> The commit below causes the error mentioned in the Subject: field. I would
> like to fix this, but could use a bit of help here how to do this type of
> things.
> 
> commit 4b681c82d2f9bef121c912ffcaac89a004af3f2c
> Author: Vadim Kochan <vadim4j@gmail.com>
> Date:   Mon Jan 12 16:34:05 2015 +0200
> 
>     nl80211: Allow set network namespace by fd
> 
> Regards,
> Arend
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi,

Did you compile it on mac80211-next master branch ?

Regards,
