Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:38501 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbYAZTpF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 14:45:05 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JIqxa-0005RL-TG
	for linux-wireless@vger.kernel.org; Sat, 26 Jan 2008 19:45:02 +0000
Received: from 195.33.116.209 ([195.33.116.209])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2008 19:45:02 +0000
Received: from Lars_Ericsson by 195.33.116.209 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2008 19:45:02 +0000
To: linux-wireless@vger.kernel.org
From: Lars <Lars_Ericsson@telia.com>
Subject: Re: [PATCH 2/2] rc80211-pid: add sanity check
Date: Sat, 26 Jan 2008 19:40:14 +0000 (UTC)
Message-ID: <loom.20080126T193518-105@post.gmane.org> (sfid-20080126_194512_395337_44D2597A)
References: <20080126040534.005e6736@morte> <200801261219.34805.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have spent some time debugging this problem from a different angle.

If you use a 'b/g' STA connecting to a 'b' AP you will run into this loop in a
few seconds. What also happens is that the STA will try using 'g' speeds. That
was the way I located the problem.

In other words, I do not think a WARN_ON is good solution.

Regards
Lars







