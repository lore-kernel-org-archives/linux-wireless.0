Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46584 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3BEKAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 05:00:10 -0500
Message-ID: <1360058432.8376.1.camel@jlt4.sipsolutions.net> (sfid-20130205_110029_067814_2A8F7103)
Subject: Re: [PATCH] mac80211: stop plink timer only on mesh interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 05 Feb 2013 11:00:32 +0100
In-Reply-To: <1360015961-5922-1-git-send-email-thomas@cozybit.com> (sfid-20130204_231408_638064_553C0C83)
References: <1360015961-5922-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130204_231408_638064_553C0C83)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 14:12 -0800, Thomas Pedersen wrote:
> Since mesh_plink_quiesce() would unconditionally delete
> the plink timer, and the timer initialization was recently
> moved into the mesh code path, suspending with a non-mesh
> interface now causes a crash. Fix this by only deleting
> the plink timer for mesh interfaces.

Applied, thanks.

johannes

