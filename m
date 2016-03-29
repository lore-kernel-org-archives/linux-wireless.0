Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51520 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956AbcC2IKA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 04:10:00 -0400
Message-ID: <1459238994.3217.0.camel@sipsolutions.net> (sfid-20160329_101005_276738_B2A4B115)
Subject: Re: [PATCH] mac80211: allow same PN for AMSDU sub-frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Date: Tue, 29 Mar 2016 10:09:54 +0200
In-Reply-To: <1457515785-18795-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1457515785-18795-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-09 at 11:29 +0200, Emmanuel Grumbach wrote:
> From: Sara Sharon <sara.sharon@intel.com>
> 
> Some hardware (iwlwifi an example) de-aggregate AMSDUs and
> copy the IV as is to the generated MPDUs, so the same PN
> appears in multiple packets without being a replay attack.
> Do not increment the PN until all the sub-frames are received
> to accommodate to that.
> 
I'll drop this for now since you found an issue with it :)

johannes
