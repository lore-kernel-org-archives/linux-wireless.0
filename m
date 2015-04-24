Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39769 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbbDXKZW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 06:25:22 -0400
Message-ID: <1429871119.1852.27.camel@sipsolutions.net> (sfid-20150424_122524_951057_08D1981D)
Subject: Re: [PATCH 1/3] iwlwifi: dvm: don't sleep in event_callback callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 24 Apr 2015 12:25:19 +0200
In-Reply-To: <1429559618-23056-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1429559618-23056-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-04-20 at 22:53 +0300, Emmanuel Grumbach wrote:
> This will allow mac80211 to forbid sleeping from the
> event_callback callback.
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
> Please apply this on mac80211-next.git since other mac80211 patches
> depend on it.

Applied all 3.

johannes

