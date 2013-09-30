Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54153 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3I3JH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 05:07:57 -0400
Message-ID: <1380532074.14467.2.camel@jlt4.sipsolutions.net> (sfid-20130930_110801_411902_052600ED)
Subject: Re: [PATCH] iwlwifi: pcie: fix merge damage
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Mon, 30 Sep 2013 11:07:54 +0200
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
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Ah, forgot to say - John, I think you should apply this as a patch,
having it in my pull request seems odd. But if you're of another opinion
I can stick it into my next -next pull request too.

johannes

