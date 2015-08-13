Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47868 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbbHMMCN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 08:02:13 -0400
Message-ID: <1439467330.2114.27.camel@sipsolutions.net> (sfid-20150813_140216_118385_FFB6761C)
Subject: Re: [PATCH 5/5] mac80211: Make OCB mode set BSSID
From: Johannes Berg <johannes@sipsolutions.net>
To: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>,
	linux-wireless@vger.kernel.org
Date: Thu, 13 Aug 2015 14:02:10 +0200
In-Reply-To: <1438783370-9442-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be>
References: <1438783370-9442-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-05 at 16:02 +0200, Bertold Van den Bergh wrote:
> Perform the BSS_CHANGED_BSSID action when joining an OCB network.
> This is required to set the broadcast BSSID in some network drivers.
> 
Also applied 4 and 5.

johannes
