Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:54996 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab1CDKFI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 05:05:08 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PvRsh-0003Zh-UM
	for linux-wireless@vger.kernel.org; Fri, 04 Mar 2011 11:05:07 +0100
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 11:05:07 +0100
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 11:05:07 +0100
To: linux-wireless@vger.kernel.org
From: jpo234 <pommnitz@yahoo.com>
Subject: Re: [PATCH] ath5k:  Put hardware in PROMISC mode if there is more than 1 stations.
Date: Fri, 4 Mar 2011 10:04:57 +0000 (UTC)
Message-ID: <loom.20110304T110306-345@post.gmane.org>
References: <1299191945-13257-1-git-send-email-greearb@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

| From: Ben Greear <greearb@...>
|  
| It seems ath5k has issues receiving broadcast packets (ARPs) when
| using multiple STA interfaces associated with multiple APs.
| This patch ensures the NIC is always in PROMISC mode if there
| are more than 1 stations associated.

Is this a band aid or a real fix? 

