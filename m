Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44622 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965166AbcBDIyu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 03:54:50 -0500
Message-ID: <1454576087.2564.1.camel@sipsolutions.net> (sfid-20160204_095452_900212_FB0D6941)
Subject: Re: [PATCH] mac80211: fix VHT MU-MIMO frame processing
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Date: Thu, 04 Feb 2016 09:54:47 +0100
In-Reply-To: <1454529143-9299-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1454529143-9299-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-02-03 at 21:52 +0200, Emmanuel Grumbach wrote:
> From: Sara Sharon <sara.sharon@intel.com>
> 
> The source and destintation addresses in the memcpy arguments
> are flipped. Fix that.
> 
Applied.

johannes
