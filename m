Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785AbaAFQmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 11:42:45 -0500
Message-ID: <1389026561.5891.37.camel@jlt4.sipsolutions.net> (sfid-20140106_174255_798543_340D91BA)
Subject: Re: [PATCH] mac80211: reorder packet checking and processing
From: Johannes Berg <johannes@sipsolutions.net>
To: Fred Chou <fred.chou.nd@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Jan 2014 17:42:41 +0100
In-Reply-To: <1387798975-17708-1-git-send-email-fred.chou.nd@gmail.com> (sfid-20131223_124110_891154_2DF4DCCD)
References: <1387798975-17708-1-git-send-email-fred.chou.nd@gmail.com>
	 (sfid-20131223_124110_891154_2DF4DCCD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-23 at 19:42 +0800, Fred Chou wrote:
> Check received packet length first and drop the packet
> if it is shorter than MAC header. Process packet after
> the checking. 

Why do you think we should do this? Your commit message is also
misleading - we already check that the patch is long enough. Too short
packets should be relatively rare anyway.

johannes

