Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57115 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbbF2H1c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 03:27:32 -0400
Message-ID: <1435562850.2156.4.camel@sipsolutions.net> (sfid-20150629_092736_741861_751DC351)
Subject: Re: [PATCH] mac80211: remove compilation warning on mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 29 Jun 2015 09:27:30 +0200
In-Reply-To: <1435549847-18680-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20150629_055104_499604_FF60252A)
References: <1435549847-18680-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20150629_055104_499604_FF60252A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-06-29 at 11:50 +0800, Chun-Yeow Yeoh wrote:
> Remove the warning on the following:
> mesh_hwmp.c: warning: ‘target_metric’ may be used
> uninitialized in this function [-Wmaybe-uninitialized]
> 
I don't see any such warning, and would prefer not to have a blanket
initialization that might in the future suppress a valid warning.

johannes
