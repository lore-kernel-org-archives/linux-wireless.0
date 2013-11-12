Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:44152 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3KLQjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 11:39:23 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] iw: add support for 5 and 10 MHz channels in IBSS mode
Date: Tue, 12 Nov 2013 17:39:21 +0100
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
References: <1384273978-11510-1-git-send-email-sw@simonwunderlich.de> <1384274088.14301.8.camel@jlt4.sipsolutions.net>
In-Reply-To: <1384274088.14301.8.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201311121739.21600.sw@simonwunderlich.de> (sfid-20131112_173926_875991_DB927FB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On Tue, 2013-11-12 at 17:32 +0100, Simon Wunderlich wrote:
> > 5/10 MHz requires to send the frequency information as chandef instead
> > of the the old channel type, this change is included here as well.
> 
> I think you need to keep the channel type to stay compatible with old
> kernels.
> 

Wow, high-speed reply (1 minute 50 seconds), and you are right. :)

I'll change that so it uses chandef only for 5/10 MHz and the old channel 
types for the rest (NOHT,HT20,HT40+,HT40-).

Thanks,
    Simon
