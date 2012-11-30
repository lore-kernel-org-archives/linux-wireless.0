Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51609 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517Ab2K3LqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 06:46:00 -0500
Message-ID: <1354275982.10035.3.camel@jlt4.sipsolutions.net> (sfid-20121130_124605_200521_FD85AD23)
Subject: Re: [RFCv2 02/13] {cfg,nl}80211: mesh power mode config parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, thomas@cozybit.com,
	linux-wireless@vger.kernel.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Date: Fri, 30 Nov 2012 12:46:22 +0100
In-Reply-To: <1353701934-12752-3-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353701934-12752-3-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 12:18 -0800, Marco Porsch wrote:
> Add the nl80211_mesh_power_mode enumeration which holds possible values for
> the mesh power mode. These modes are unknown, active, light sleep and
> deep sleep.
> 
> Add power_mode entry to the mesh config structure to hold the user-configured
> default mesh power mode. This value will be used for new peer links. Make the
> default mesh power mode accessible to userspace as part of the mesh config.

missing range checks.

johannes

