Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51189 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbaCCMtW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 07:49:22 -0500
Message-ID: <1393850958.10039.0.camel@jlt4.sipsolutions.net> (sfid-20140303_134925_965308_117F01EC)
Subject: Re: [PATCH] mac80211: consider virtual mon when calculating min_def
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Date: Mon, 03 Mar 2014 13:49:18 +0100
In-Reply-To: <1393846634-21264-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1393846634-21264-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-03 at 13:37 +0200, Emmanuel Grumbach wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> When calculating the current max bw required for
> a channel context, we didn't consider the virtual
> monitor interface, resulting in its channel context
> being narrower than configured.

Applied. I decided to drop the Cc stable since our driver usage of this
is only in 3.14 so before that it doesn't really matter.

johannes

