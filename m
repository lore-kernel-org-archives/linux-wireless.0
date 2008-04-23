Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:61496 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140AbYDWRNM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 13:13:12 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: "'Dan Williams'" <dcbw@redhat.com>,
	<linux-wireless@vger.kernel.org>, <hostap@lists.shmoo.com>
Subject: RE: Roaming problems
Date: Wed, 23 Apr 2008 19:12:14 +0200
Message-ID: <006b01c8a565$2dd40a10$0b3ca8c0@gotws1589> (sfid-20080423_191352_839981_070E2D3E)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <1208969605.31429.88.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Currently this is what happens most of the time, when all 
> ioclts had 
> > been issued from the driver, it drops current 
> > authentication/association atempts and start with the new 
> one. Most of the times that works fine.
> > 
> > But sometimes, when for any reason the 3 ioctls get delayed, the 
> > driver may success to associate with the old BSSID (since that is 
> > still valid in the driver). Then when all 3 ioctls has been 
> received, 
> > including the new BSSID, the driver re-starts the 
> > authentication/association sequence with the new BSSID.
> > 
> > The problem is that the STA already have a valid 
> association with the 
> > first AP. In this case the new BSSID silently ignores any 
> > authentication/association attempts. My believe is that it 
> knows that 
> > the STA already have a valid association.
> 
> Uh huh. Aren't we disassociating when we change to a new bssid?
> 

I think the best way would be check the trace I attached in the first post.

/LaE


