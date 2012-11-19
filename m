Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab2KSPMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 10:12:01 -0500
Message-ID: <1353337951.18299.25.camel@jlt4.sipsolutions.net> (sfid-20121119_161206_245265_37985AB9)
Subject: Re: [PATCH v2] mac80211: make remain_on_channel() op pass vif param
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Nov 2012 16:12:31 +0100
In-Reply-To: <1353337509-6883-1-git-send-email-eliad@wizery.com> (sfid-20121119_160511_503306_7306DCE9)
References: <1353337509-6883-1-git-send-email-eliad@wizery.com>
	 (sfid-20121119_160511_503306_7306DCE9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 17:05 +0200, Eliad Peller wrote:
> Drivers (e.g. wl12xx) might need to know the vif
> to roc on (mainly in order to configure the
> rx filters correctly).
> 
> Add the vif to the op params, and update the current
> users (iwlwifi) to use the new api.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
> v2: don't combine ROC requests on different vifs (thanks Johannes!)

Thanks, applied.

johannes

