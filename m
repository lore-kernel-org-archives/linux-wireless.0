Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44205 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076Ab0JLIDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 04:03:08 -0400
Subject: Re: [RFC] ath5k:  Move debugfs under ieee80211/[wiphy-name]
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1286824841-30822-1-git-send-email-greearb@candelatech.com>
References: <1286824841-30822-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 10:03:04 +0200
Message-ID: <1286870584.3753.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 12:20 -0700, greearb@candelatech.com wrote:

>  void
>  ath5k_debug_init(void)
>  {
> -	ath5k_global_debugfs = debugfs_create_dir("ath5k", NULL);
>  }

I didn't really intend for my patch to get merged -- at least you should
also remove this now useless function and its callers and prototypes.

johannes

