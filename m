Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37827 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbaE1OEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 10:04:32 -0400
Message-ID: <1401285862.8146.23.camel@jlt4.sipsolutions.net> (sfid-20140528_160434_718932_A01E4F07)
Subject: Re: [PATCH] mac80211: set new interfaces as idle upon init
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>
Date: Wed, 28 May 2014 16:04:22 +0200
In-Reply-To: <1400750267-2259-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1400750267-2259-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 12:17 +0300, Emmanuel Grumbach wrote:
> From: Avraham Stern <avraham.stern@intel.com>
> 
> Mark new interfaces as idle to allow operations that require that
> interfaces are idle to take place. Interface types that are always
> not idle (like AP interfaces) will be set as not idle when they are
> assigned a channel context.

Applied.

johannes

