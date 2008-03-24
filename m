Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2153 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbYCXUHQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2008 16:07:16 -0400
Date: Mon, 24 Mar 2008 15:44:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Helge Deller <deller@gmx.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	mickflemm@gmail.com
Subject: Re: ath5k aborts wireless connections
Message-ID: <20080324194443.GA16065@tuxdriver.com> (sfid-20080324_200736_065077_E21FFF19)
References: <200803221129.59090.deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200803221129.59090.deller@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 22, 2008 at 11:29:58AM +0100, Helge Deller wrote:

> Around 2-5 minutes later the driver suddenly disconnects and syslog reports the following messages.
> Since then, ath5k will not reconnect any longer to the router.
> 
> wlan1: invalid Michael MIC in data frame from 00:15:0c:e1:c0:96
> wlan1: invalid Michael MIC in data frame from 00:15:0c:e1:c0:96
> wlan1: RX disassociation from 00:50:18:3b:2b:04 (reason=1)
> wlan1: disassociated
> wlan1: deauthenticate(reason=14)

"Message integrity field (MIC) failure" -- doesn't look good.

I've seen a few reports of data corruption with ath5k.  Maybe it is
clobbering its own frames too?

John
-- 
John W. Linville
linville@tuxdriver.com
