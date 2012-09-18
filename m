Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41467 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2IRRtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 13:49:43 -0400
Message-ID: <1347990615.4283.14.camel@jlt4.sipsolutions.net> (sfid-20120918_194946_400187_3364EF52)
Subject: Re: [PATCH v3.6] iwlwifi: don't double free the interrupt in
 failure path
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Tue, 18 Sep 2012 19:50:15 +0200
In-Reply-To: <1347990539-27214-1-git-send-email-johannes@sipsolutions.net> (sfid-20120918_194832_816361_F02AB21B)
References: <1347990539-27214-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120918_194832_816361_F02AB21B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-18 at 19:48 +0200, Johannes Berg wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> When the driver can't get the HW ready, we would release
> the interrupt twice which made the kernel complain loudly.

John, can you please pick this up for 3.6? I seem to have lost this
patch somewhere in the process by accident.

johannes

