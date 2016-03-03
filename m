Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56372 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbcCCO5a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 09:57:30 -0500
Message-ID: <1457017045.2044.13.camel@sipsolutions.net> (sfid-20160303_155744_681382_2E4D96A1)
Subject: Re: [PATCH v3] mac80211: allow not sending MIC up from driver for
 HW crypto
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Date: Thu, 03 Mar 2016 15:57:25 +0100
In-Reply-To: <1456307385-23014-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1455614328-12528-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1456307385-23014-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-02-24 at 11:49 +0200, Emmanuel Grumbach wrote:
> From: Sara Sharon <sara.sharon@intel.com>
> 
> When HW crypto is used, there's no need for the CCMP/GCMP MIC to
> be available to mac80211, and the hardware might have removed it
> already after checking. The MIC is also useless to have when the
> frame is already decrypted, so allow indicating that it's not
> present.
> 
> Since we are running out of bits in mac80211_rx_flags, make
> the flags field a u64.
> 
Applied.

johannes
