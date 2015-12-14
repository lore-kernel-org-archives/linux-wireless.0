Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55843 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbbLNMWj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:22:39 -0500
Message-ID: <1450095756.3871.15.camel@sipsolutions.net> (sfid-20151214_132246_888400_BF4C9C9B)
Subject: Re: [PATCH 00/14] mwifiex fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <akarwar@marvell.com>,
	linux-wireless@vger.kernel.org
Cc: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Date: Mon, 14 Dec 2015 13:22:36 +0100
In-Reply-To: <1450095315-19927-1-git-send-email-akarwar@marvell.com> (sfid-20151214_131706_754762_207FCAEE)
References: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
	 (sfid-20151214_131706_754762_207FCAEE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-12-14 at 04:15 -0800, Amitkumar Karwar wrote:
> These patches include few fixes for mwifiex and add a
> debugfs file for chip reset.
> 

A lot of these "fixes" look like new firmware features to me (e.g.
interface limits, sms4 cipher, pattern length).

First of all - is that really appropriate as "fixes", what tree are you
targeting?

And secondly, how are you making sure the user won't have an older
firmware version where this will presumably cause crashes?

johannes
