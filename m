Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56890 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176AbbDNPJ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 11:09:29 -0400
Message-ID: <1429024166.3019.17.camel@sipsolutions.net> (sfid-20150414_170933_132487_24A8ECA1)
Subject: Re: [PATCH] mwifiex: increase number of probes for specific SSID
 scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Tue, 14 Apr 2015 17:09:26 +0200
In-Reply-To: <1429022956-12016-1-git-send-email-akarwar@marvell.com> (sfid-20150414_164959_065629_FE6FF99B)
References: <1429022956-12016-1-git-send-email-akarwar@marvell.com>
	 (sfid-20150414_164959_065629_FE6FF99B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-04-14 at 07:49 -0700, Amitkumar Karwar wrote:
> It's been observed that device sometimes fails to find AP
> configured in hidden SSID in busy environment. We will increase
> number of probes for specific SSID scans for getting better results.

I question the value of making the "busy environment" even more busy by
sending a lot of probe requests at low rates ...

Scans are never really guaranteed to be perfect and complete anyway.

This is clearly your choice, but given, among other things, the broader
industry direction of moving away from active scanning this seems like a
bit short-sighted thing to do.

johannes

