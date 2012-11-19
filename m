Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2KSOoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 09:44:15 -0500
Message-ID: <1353336285.18299.14.camel@jlt4.sipsolutions.net> (sfid-20121119_154418_622593_DFF1FD91)
Subject: Re: [PATCH] mac80211: make remain_on_channel() op pass vif param
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Nov 2012 15:44:45 +0100
In-Reply-To: <1353239862-11313-1-git-send-email-eliad@wizery.com> (sfid-20121118_125746_467015_381F2198)
References: <1353239862-11313-1-git-send-email-eliad@wizery.com>
	 (sfid-20121118_125746_467015_381F2198)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-11-18 at 13:57 +0200, Eliad Peller wrote:
> Drivers (e.g. wl12xx) might need to know the vif
> to roc on (mainly in order to configure the 
> rx filters correctly).
> 
> Add the vif to the op params, and update the current
> users (iwlwifi) to use the new api.

Hmm, ok, but I think then the ROC merge logic may have to be changed?

johannes

