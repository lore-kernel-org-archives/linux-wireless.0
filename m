Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52537 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550AbbBTQ6q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 11:58:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YOqua-00066S-QH
	for linux-wireless@vger.kernel.org; Fri, 20 Feb 2015 17:58:45 +0100
Received: from 194.144-252-62.static.virginmediabusiness.co.uk ([194.144-252-62.static.virginmediabusiness.co.uk])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2015 17:58:44 +0100
Received: from miketurner.forum by 194.144-252-62.static.virginmediabusiness.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2015 17:58:44 +0100
To: linux-wireless@vger.kernel.org
From: Mike Turner <miketurner.forum@gmail.com>
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix some beacon issue
Date: Fri, 20 Feb 2015 16:58:32 +0000 (UTC)
Message-ID: <loom.20150220T175341-637@post.gmane.org> (sfid-20150220_175849_822632_04DACBA3)
References: <1424443813-13634-1-git-send-email-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taehee Yoo <ap420073@...> writes:

> 
> Sometimes rtl8192cu is not sending beacon frame.
> This patch fix this issue.
> 
> Signed-off-by: Taehee Yoo <ap420073@...>



Tried this and it doesn't help. Beacon transmission still isn't 
consistent. Can hostapd have an effect on this?


