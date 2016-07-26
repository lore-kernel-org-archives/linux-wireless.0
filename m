Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.tech.triadic.us ([98.102.61.98]:53228 "EHLO
	SMTP.Tech.Triadic.US" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbcGZE6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2016 00:58:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 26 Jul 2016 00:38:51 -0400
From: alexmcwhirter@triadic.us
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Alan Curry <rlwinm@sdf.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: PROBLEM: network data corruption (bisected to e5a4b0bb803b)
In-Reply-To: <1659922.nTqITfJpFk@debian64>
References: <201607240335.u6O3ZE81014171@sdf.org>
 <1659922.nTqITfJpFk@debian64>
Message-ID: <5ad66efb31d2febc2a4fda0be591815b@triadic.us> (sfid-20160726_065836_178557_DDBE1541)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Thanks for the detailed bug-report. I looked around the web to see if 
> it
> was already reported or not. If found that this issue was reported 
> before:
> [0], [1] and [2] by the same person (CC'ed). One difference is that the
> reporter had this issue with rsync on multiple SPARC systems. I ran a
> git grep on a 4.7.0-rc7+ (wt-2016-07-21-15-g97bd3b0). But it didn't 
> find
> any patches directly referencing the commit. I'm not sure if this issue
> has been fixed by now or not. I would greatly appreciate any comment
> about this from the "people of netdev" (Al Viro? Alex Mcwhirter?).

I can confirm the issue i was having with this commit still exists on 
sparc with the latest mainline kernel.
