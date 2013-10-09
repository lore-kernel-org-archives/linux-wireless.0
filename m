Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3JIIDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 04:03:09 -0400
Message-ID: <1381305785.14186.4.camel@jlt4.sipsolutions.net> (sfid-20131009_100408_089102_2D821769)
Subject: Re: [PATCHv2 2/3] mac80211: enable DFS for IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 09 Oct 2013 10:03:05 +0200
In-Reply-To: <1381164067-4830-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1381164067-4830-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1381164067-4830-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-07 at 18:41 +0200, Simon Wunderlich wrote:
> Allow changing to DFS channels if the channel is available for
> beaconing and userspace controls DFS operation.
> 
> Channel switch announcement from other stations on DFS channels will
> be interpreted as radar event. These channels will then be marked as
> unvailable.

Applied

johannes

