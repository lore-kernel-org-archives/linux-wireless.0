Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29590 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198Ab0KJWk1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 17:40:27 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 14:40:15 -0800
Date: Wed, 10 Nov 2010 14:40:25 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Vivek Natarajan <Vivek.Natarajan@Atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] compat/ath9k: pm-qos params patch
Message-ID: <20101110224025.GK4667@tux>
References: <1289382968-4165-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1289382968-4165-1-git-send-email-vnatarajan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 10, 2010 at 01:56:08AM -0800, Vivek Natarajan wrote:
> This patch is similar to the one for ipw2x00:
> This patch is required because now pm-qos has 3 different flavors:
> 
> On kernels >= 2.6.36 the pm qos req is kzalloc()'d by pm-qos itself
> On kernel   = 2.6.35 the pm qos req uses the stack
> On kernels <  2.6.35 the pm qos req is pegged to a unique name.
> 
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>

Vivek, what tree is this for? It seems to me you want to
patch up ath9k for compat-wireless. If so that would go
through compat-wireless.git and you'd add the hunks below
to patches/28-pm-qos-params.patch.

Is this going to be required for our compat-wireless-2.6.36 release,
the compat-wireless-2.6.37 or will this just be for compat-wireless-2.6.38?

  Luis
