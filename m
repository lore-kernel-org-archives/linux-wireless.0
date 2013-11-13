Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45230 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3KMS07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:26:59 -0500
Message-ID: <1384367215.14578.16.camel@jlt4.sipsolutions.net> (sfid-20131113_192702_829391_EB3093CC)
Subject: Re: [PATCH] mac80211: move csa_chandef to sdata
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Wed, 13 Nov 2013 19:26:55 +0100
In-Reply-To: <1384194894-26935-1-git-send-email-egrumbach@gmail.com> (sfid-20131111_193503_425890_13DAE466)
References: <1384194894-26935-1-git-send-email-egrumbach@gmail.com>
	 (sfid-20131111_193503_425890_13DAE466)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-11 at 20:34 +0200, Emmanuel Grumbach wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> There is no reason why we should have only one channel switch
> announcement at a time for a single phy.  When support for channel
> switch with multiple contexts and multiple vifs per context is
> implemented, we will need the chandef data for each vif.  Move the
> csa_chandef structure to sdata to prepare for this.

Applied.

johannes

