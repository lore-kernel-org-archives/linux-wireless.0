Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1KBH5v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 03:57:51 -0400
Subject: Re: [wireless-next PATCH v2 1/4] mac80211: Support forcing station
 to disable 11n.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1319840474-2618-1-git-send-email-greearb@candelatech.com> (sfid-20111029_002128_214854_3ACBE979)
References: <1319840474-2618-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111029_002128_214854_3ACBE979)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 08:57:46 +0100
Message-ID: <1320220666.3950.6.camel@jlt3.sipsolutions.net> (sfid-20111102_085753_200623_F5DFC436)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-28 at 15:21 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This allows a user to configure a wifi station interface
> to disable 802.11n, even if the AP and NIC supports it.

You really should've waited for the review on v1 to finish -- this v2 is
worthless. That makes John think that you addressed all review feedback,
when really we didn't even finish discussing some points; eventually
that'll just force me to have my own tree so John isn't confused all the
time.

johannes

