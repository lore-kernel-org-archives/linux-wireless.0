Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55975 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbaIKKWV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:22:21 -0400
Message-ID: <1410430937.22863.6.camel@jlt4.sipsolutions.net> (sfid-20140911_122224_477361_9A57C78D)
Subject: Re: [PATCH] cfg80211: add WMM traffic stream API
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Sep 2014 12:22:17 +0200
In-Reply-To: <1410292535-15150-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1410292535-15150-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-09-09 at 22:55 +0300, Emmanuel Grumbach wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add nl80211 and driver API to validate, add and delete traffic
> streams with appropriate settings.
> 
> The API calls for userspace doing the action frame handshake
> with the peer, and then allows only to set up the parameters
> in the driver. To avoid setting up a session only to tear it
> down again, the validate API is provided, but the real usage
> later can still fail so userspace must be prepared for that.

Applied.

johannes

