Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57918 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbaEZI2D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 04:28:03 -0400
Message-ID: <1401092877.19055.4.camel@jlt4.sipsolutions.net> (sfid-20140526_102807_259973_3EE81697)
Subject: Re: [PATCH] mac80211: docs: remove spurious blank line that causes
 docbook warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 May 2014 10:27:57 +0200
In-Reply-To: <1401085812-21040-1-git-send-email-luca@coelho.fi>
References: <1401085812-21040-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-05-26 at 09:30 +0300, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> When making htmldocs (at least) the following warning was being generated:
> 
> Warning(/home/luca/kvm-shared/git/public/mac80211-next//include/net/mac80211.h:2770): bad line:
> 
> The cause was a stray empty line inside a block of documentation.  Fix this.

Applied.

johannes

