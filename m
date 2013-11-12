Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab3KLJnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 04:43:24 -0500
Message-ID: <1384249399.14301.4.camel@jlt4.sipsolutions.net> (sfid-20131112_104328_010647_C5EBEABE)
Subject: Re: [PATCH] mac80211: fix for mesh beacon update on powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Lopez <jlopex@cozybit.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	marco@cozybit.com
Date: Tue, 12 Nov 2013 10:43:19 +0100
In-Reply-To: <1383761069-31615-1-git-send-email-jlopex@cozybit.com> (sfid-20131106_190448_970689_5CED3647)
References: <1383761069-31615-1-git-send-email-jlopex@cozybit.com>
	 (sfid-20131106_190448_970689_5CED3647)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-06 at 10:04 -0800, Javier Lopez wrote:
> Mesh beacon was not being rebuild after user triggered a mesh
> powersave change.
> 
> To solve this issue use ieee80211_mbss_info_change_notify instead
> of ieee80211_bss_info_change_notify. This helper function forces
> mesh beacon to be rebuild and then notifies the driver about the
> beacon change.

Applied.

johannes

