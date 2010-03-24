Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0CXV2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 17:28:36 -0400
Subject: Re: [PATCH] compat-wireless: update 22-multiqueue.patch for the
 current linux-next
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100324212520.15474.94735.stgit@mj.roinet.com>
References: <20100324212520.15474.94735.stgit@mj.roinet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 14:28:42 -0700
Message-ID: <1269466122.6935.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-24 at 17:25 -0400, Pavel Roskin wrote:
> Adjust for spacing change in net/mac80211/util.c.  Add a replacement for
> netif_tx_wake_queue() for net/mac80211/tx.c
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>  0 files changed, 0 insertions(+), 0 deletions(-)

Out of curiosity, how did you manage to generate that?

johannes

