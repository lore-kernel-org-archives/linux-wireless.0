Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:43220 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab1FVIjt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 04:39:49 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QZIyQ-0003vR-B5
	for linux-wireless@vger.kernel.org; Wed, 22 Jun 2011 10:39:46 +0200
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 10:39:46 +0200
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 10:39:46 +0200
To: linux-wireless@vger.kernel.org
From: jpo <pommnitz@yahoo.com>
Subject: Re: [RFC v2] hostapd: add Automatic Channel Selection (ACS) support
Date: Wed, 22 Jun 2011 08:39:34 +0000 (UTC)
Message-ID: <loom.20110622T103452-665@post.gmane.org> (sfid-20110622_103954_247447_25C0C7E7)
References: <1308704862-5684-1-git-send-email-lrodriguez@atheros.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <lrodriguez@...> writes:

> 
> This adds Automatic Channel Selection (ACS) support to hostapd
> using the Survery based ACS algorithm [1].

Will there be a command line tool for IBSS? I imagine something like
iw dev wlan0 ibss join "TheNetwork" $(acstool dev wlan0)
or as part of iw
iw dev wlan0 ibss join "TheNetwork" acs



