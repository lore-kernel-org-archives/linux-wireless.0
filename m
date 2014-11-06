Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40403 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaKFWbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 17:31:18 -0500
Message-ID: <545BF6B5.6050205@candelatech.com> (sfid-20141106_233133_350096_5C54B68D)
Date: Thu, 06 Nov 2014 14:31:17 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: add back support for radiotap vendor namespace
 data
References: <1415312956-9442-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1415312956-9442-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/06/2014 02:29 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Radiotap vendor namespace data might still be useful, but we
> reverted it because it used too much space in the RX status.
> Put it back, but address the space problem by using a single
> but only and putting everything else into the skb->data.

  ^^ typo?

I didn't look at the rest...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

