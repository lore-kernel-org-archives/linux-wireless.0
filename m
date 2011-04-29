Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57323 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab1D2MuY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 08:50:24 -0400
Received: by fxm17 with SMTP id 17so2466631fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 05:50:23 -0700 (PDT)
Subject: Re: [PATCH 4/4] mac80211: Add IEEE802.11n for IBSS
From: Alexander Simon <alexander.simon@saxnet.de>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1304080747.21342.1.camel@jlt3.sipsolutions.net>
References: <1302604964.2139.5.camel@alex-2>
	 <loom.20110412T130620-109@post.gmane.org>
	 <1302607159.3639.8.camel@jlt3.sipsolutions.net>
	 <loom.20110428T135917-421@post.gmane.org>
	 (sfid-20110428_141415_832084_99A2E356) <1303995368.3558.9.camel@jlt3.sipsolutions.net>
	 <loom.20110429T084118-365@post.gmane.org>
	 (sfid-20110429_085443_970145_470B3272)  <1304061675.3589.1.camel@jlt3.sipsolutions.net>
	 <1304066264.2931.23.camel@alex-2>  <1304080563.2931.41.camel@alex-2>
	 (sfid-20110429_143612_006856_91560407)  <1304080747.21342.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 14:50:21 +0200
Message-ID: <1304081421.2931.47.camel@alex-2> (sfid-20110429_145028_319231_DD336FE8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > - If HT has been configured through iw and a non-HT network is to be
> > joined, iw's HT setting is used and announced.
> 
> This isn't possible, you might join a network on a channel that doesn't
> allow HT40+ for example.
Of course it must be checked.
It has to be checked even when joining HT networks.
E.g. a european user travels to America and opens an HT+ Network on
channel 9. The american card should disable HT40+.


