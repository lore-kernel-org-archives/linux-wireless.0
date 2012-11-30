Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51687 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2K3MLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 07:11:51 -0500
Message-ID: <1354277533.10035.21.camel@jlt4.sipsolutions.net> (sfid-20121130_131154_156401_9D371136)
Subject: Re: [RFCv2 10/13] {cfg,nl}80211: add awake window to mesh config
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, thomas@cozybit.com,
	linux-wireless@vger.kernel.org
Date: Fri, 30 Nov 2012 13:12:13 +0100
In-Reply-To: <1353701934-12752-11-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353701934-12752-11-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 12:18 -0800, Marco Porsch wrote:
> This commit adds the dot11MeshAwakeWindowDuration value to the mesh config.
> The awake window is a duration in TU describing how long the STA will stay
> awake after transmitting its beacon in PS mode.
> The value can be changed during mesh runtime.
> 

again missing range checks?

