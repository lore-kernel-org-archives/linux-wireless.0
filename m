Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53601 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2FTPjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 11:39:21 -0400
Message-ID: <1340206759.4655.74.camel@jlt3.sipsolutions.net> (sfid-20120620_173924_050817_A0E49A6C)
Subject: Re: [PATCH] mac80211: save wmm_acm per sdata
From: Johannes Berg <johannes@sipsolutions.net>
To: Yoni Divinsky <yoni.divinsky@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2012 17:39:19 +0200
In-Reply-To: <1340195953-25343-1-git-send-email-yoni.divinsky@ti.com>
References: <1340195953-25343-1-git-send-email-yoni.divinsky@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 15:39 +0300, Yoni Divinsky wrote:
> Save and configure the wmm_acm per sdata, rather than
> per hardware.
> 
> If wmm_acm is saved per hardware when running two
> interfaces simultaneously on the same hardware one
> interface's wmm policy will be affected by the other
> interface.

> +	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */

applied, but I moved this variable to a better spot

johannes

