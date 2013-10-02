Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35440 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab3JBJlu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 05:41:50 -0400
Message-ID: <1380706904.13329.15.camel@jlt4.sipsolutions.net> (sfid-20131002_114153_477560_29BA242A)
Subject: Re: [PATCH] iwlwifi: pcie: fix merge damage
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Wed, 02 Oct 2013 11:41:44 +0200
In-Reply-To: <1380531766-15384-1-git-send-email-johannes@sipsolutions.net> (sfid-20130930_110300_453054_8E26BCBD)
References: <1380531766-15384-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130930_110300_453054_8E26BCBD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-30 at 11:02 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The merge b35c8097 seems to have lost commit eabc4ac5d,
> put the code back.

I'm rebasing my tree on -rc1, which actually includes the merge commit,
so it still makes sense for me to include this commit - I've done that
now. Sorry for the confusion.

johannes

