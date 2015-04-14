Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:50863 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbbDNUhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 16:37:37 -0400
Date: Wed, 15 Apr 2015 06:37:24 +1000
From: James Cameron <quozl@laptop.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: Re: [PATCH] mwifiex: increase number of probes for specific SSID
 scans
Message-ID: <20150414203724.GB32455@us.netrek.org> (sfid-20150414_223741_269481_B892574E)
References: <1429022956-12016-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1429022956-12016-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 14, 2015 at 07:49:16AM -0700, Amitkumar Karwar wrote:
> It's been observed that device sometimes fails to find AP
> configured in hidden SSID in busy environment. We will increase
> number of probes for specific SSID scans for getting better results.

I don't like this.  It worries me.  What is the underlying cause?  If
it is something other than collision, why?

In scenario of tens to a hundred laptops scanning for specific SSID
for ad-hoc in the Sugar desktop environment, this patch may decrease
free air time considerably.

Should the number of probes be a choice of user space?

-- 
James Cameron
http://quozl.linux.org.au/
