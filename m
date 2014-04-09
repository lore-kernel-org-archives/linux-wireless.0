Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41989 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaDIHrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 03:47:33 -0400
Message-ID: <1397029645.4964.1.camel@jlt4.sipsolutions.net> (sfid-20140409_094736_173570_C1EB32EB)
Subject: Re: iwlwifi: Invalid RXON when trying to join IBSS network
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Pietsch <stefan.pietsch@lsexperts.de>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Apr 2014 09:47:25 +0200
In-Reply-To: <534464F9.1080805@sp.consulting.lsexperts.de> (sfid-20140408_233636_176148_44D5A66B)
References: <534464F9.1080805@sp.consulting.lsexperts.de>
	 (sfid-20140408_233636_176148_44D5A66B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-04-08 at 23:07 +0200, Stefan Pietsch wrote:
> Dear list,
> 
> trying to join an IBSS network gives me these kernel messages:
> 
> 
> 
> [  383.857059] iwlwifi 0000:03:00.0: mac/bssid mcast!

How did you manage to get a multicast address as the BSSID?

johannes

