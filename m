Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35331 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143AbaKENpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 08:45:08 -0500
Message-ID: <1415195100.7485.1.camel@sipsolutions.net> (sfid-20141105_144525_162971_FA51749C)
Subject: Re: [PATCH] mwifiex: module load parameter for interface creation
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <patila@marvell.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	cluo@marvell.com, yangyang@marvell.com,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 05 Nov 2014 14:45:00 +0100
In-Reply-To: <1415196491-25391-1-git-send-email-patila@marvell.com> (sfid-20141105_093859_779701_4AEAB3EA)
References: <1415196491-25391-1-git-send-email-patila@marvell.com>
	 (sfid-20141105_093859_779701_4AEAB3EA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-05 at 19:38 +0530, Avinash Patil wrote:
> This patch adds module load parameter driver_mode for mwifiex
> which would enable driver to create AP or P2P client interface while loading
> module. driver_mode is bitmap of interface modes for station, AP and
> P2P client.
> 
> Station interface is created by default and is unaffected by driver_mode
> parameter.

Not really sure why this would make sense or be needed, you can always
create the interfaces from userspace?

johannes

