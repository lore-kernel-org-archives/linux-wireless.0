Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li59-9.members.linode.com ([97.107.129.9]:48053 "EHLO erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0AVUXT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 15:23:19 -0500
MIME-Version: 1.0
Date: Fri, 22 Jan 2010 15:23:16 -0500
From: <pat-lkml@erley.org>
To: Markus Baier <Markus_Baier@web.de>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: Starting hostapd causes kernel panic
In-Reply-To: <loom.20100122T205326-794@post.gmane.org>
References: <loom.20100122T205326-794@post.gmane.org>
Message-ID: <eba66e02dda0a3ec904374a80ea9a1e9@127.0.0.1>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 22 Jan 2010 20:14:36 +0000 (UTC), Markus Baier
<Markus_Baier@web.de> wrote:
> After the latest git pull from wireless-testing
> master-2010-01-14 to master-2010-01-19
> the start of hostapd causes kernel panic.
> 
> Tested with wireless-testing master-2010-01-19
> and hostapd 0.6.9 / 0.7.0
> 
> 
> ---------------------------------------------
<SNIP>

I'm seeing this with git-tip of hostapd as well (using ath9k 
instead of rt61pci).  I hadn't caught a full trace, so I 
hadn't reported it yet.  On my system, it doesnt' fail until 
something actively scans and we receive the probe.  I can't 
provide more info than that yet, though.

Pat Erley
