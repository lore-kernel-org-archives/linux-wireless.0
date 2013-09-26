Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:42494 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752223Ab3IZSDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 14:03:01 -0400
Message-ID: <1380218576.17366.76.camel@joe-AO722> (sfid-20130926_200306_358749_F3AF1517)
Subject: Re: [PATCH 00/11 - GIT PULL] drivers: net: Last block of Remove
 extern from function prototypes
From: Joe Perches <joe@perches.com>
To: David Miller <davem@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	wimax@linuxwimax.org, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	brcm80211-dev-list@broadcom.com
Date: Thu, 26 Sep 2013 11:02:56 -0700
In-Reply-To: <20130926.134408.91633054642517467.davem@redhat.com>
References: <cover.1380137609.git.joe@perches.com>
	 <20130926.134408.91633054642517467.davem@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-09-26 at 13:44 -0400, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Wed, 25 Sep 2013 12:37:18 -0700
[]
> Pulled, thanks Joe.
> That should be about it for networking right?

Yes for drivers/net/...

There are some more files like:

include/linux/etherdevice.h
include/linux/inetdevice.h
include/linux/net.h
include/linux/netdevice.h
include/linux/skbuff.h

and some netfilter ones:

include/linux/netfilter*.h
include/linux/netfilter/...

and maybe a few others like:

include/linux/atmdev.h
include/linux/fddidevice.h

that I was planning on converting then submitting.

Want those in one more pull request or
maybe individually?

