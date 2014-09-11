Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56571 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbaIKLhg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 07:37:36 -0400
Message-ID: <1410435452.22863.12.camel@jlt4.sipsolutions.net> (sfid-20140911_133739_908136_7A0D398F)
Subject: Re: [PATCH 1/3] cfg80211: allow requesting SMPS mode on ap start
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Date: Thu, 11 Sep 2014 13:37:32 +0200
In-Reply-To: <1410347256-9324-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1410347256-9324-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-09-10 at 14:07 +0300, Emmanuel Grumbach wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> Add feature bits to indicate device support for
> static-smps and dynamic-smps modes.
> 
> Add a new NL80211_ATTR_SMPS_MODE attribue to allow
> configuring the smps mode to be used by the ap
> (e.g. configuring to ap to dynamic smps mode will
> reduce power consumption while having minor effect
> on throughput)

Applied all three.

johannes

