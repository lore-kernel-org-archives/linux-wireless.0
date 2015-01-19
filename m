Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35673 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbbASR7L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 12:59:11 -0500
Message-ID: <1421690349.1965.40.camel@sipsolutions.net> (sfid-20150119_185915_445043_236CD851)
Subject: Re: [PATCH] mac80211: delete the assoc/auth timer upon suspend
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Jan 2015 18:59:09 +0100
In-Reply-To: <1421679186-10898-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1421679186-10898-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-19 at 16:53 +0200, Emmanuel Grumbach wrote:
> While suspending, we destroy the authentication /
> association that might be taking place. While doing so, we
> forgot to delete the timer which can be firing after
> local->suspended is already set, producing the warning below.
> 
> Fix that by deleting the timer.

Applied.

johannes

