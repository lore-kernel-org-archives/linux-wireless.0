Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33343 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaA0Jb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 04:31:59 -0500
Message-ID: <1390815111.4251.2.camel@jlt4.sipsolutions.net> (sfid-20140127_103202_234051_9E53102A)
Subject: Re: [PATCH] mac80211: release the channel in error path in start_ap
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 Jan 2014 10:31:51 +0100
In-Reply-To: <1390813662-19032-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1390813662-19032-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-27 at 11:07 +0200, Emmanuel Grumbach wrote:
> When the driver cannot start the AP or when the assignement
> of the beacon goes wrong, we need to unassign the vif.

Applied, thanks.

johannes

