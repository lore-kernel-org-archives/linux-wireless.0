Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:29859 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbZHFL64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 07:58:56 -0400
Message-ID: <4A7AC555.301@nokia.com>
Date: Thu, 06 Aug 2009 14:58:13 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Kalle Valo <kalle.valo@iki.fi>
CC: Bob Copeland <me@bobcopeland.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wl12xx: make irq handling interface specific
References: <20090804033908.GA1903@hash.localnet>	<87hbwoniog.fsf@litku.valot.fi> <20090804122229.GA3337@hash.localnet>	<877hxionnt.fsf@litku.valot.fi> <20090805135618.GA7468@hash.localnet> <873a86nfhr.fsf@litku.valot.fi>
In-Reply-To: <873a86nfhr.fsf@litku.valot.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Kalle Valo wrote:
> Luca, I'm pretty sure that the workaround helps with wl1271 also. Just
> take the wl->channel fix and the filter hack and it should work.
>   

Excellent! This actually works! I'm sure I had tried to disable all 
filters on my wl1271 tree, but I had broken something elsewhere, so it 
didn't work.  Now I disabled the filters as you suggested in a clean 
tree and I can scan, associate, run dhcp, ping etc. with wl1271 on top 
of wireless-testing.

Now I'm cleaning up my mess to send the wl1271 driver to the list ;)

-- 
Cheers,
Luca.

