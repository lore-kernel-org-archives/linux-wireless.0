Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:61695 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab0CQLal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 07:30:41 -0400
From: <ext-saravanan.dhanabal@nokia.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 17 Mar 2010 12:09:40 +0100
Subject: RE: [PATCH] mac80211: Reschedule dynamic power save timer after
 wakeup
Message-ID: <04BB8F4F2843A24294353CA037CA5B58568D26B52F@NOK-EUMSG-01.mgdnok.nokia.com>
References: <1268753462-18094-1-git-send-email-ext-saravanan.dhanabal@nokia.com>,<1268775761.8918.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1268775761.8918.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In worst case it takes up to that much,  though the average is less but still significant. 

regards
saravanan 
________________________________________
From: ext Johannes Berg [johannes@sipsolutions.net]
Sent: Tuesday, March 16, 2010 11:42 PM
To: Dhanabal Saravanan (EXT-Sasken/Tampere)
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Reschedule dynamic power save timer after wakeup

On Tue, 2010-03-16 at 11:31 -0400, Saravanan Dhanabal wrote:
> After last transmission, the device goes to sleep earlier
> than the configured dynamic power save timeout. If timeout
> is set to 400ms, device enters into sleep mode at around
> 330ms since from last TX.

So that means the scheduling to the workqueue takes you 70ms?

johannes

