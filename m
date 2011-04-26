Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48217 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab1DZTPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 15:15:46 -0400
Date: Tue, 26 Apr 2011 15:11:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] cfg80211: Add channel type for IBSS
Message-ID: <20110426191146.GI2804@tuxdriver.com> (sfid-20110426_211552_667542_037A76B2)
References: <1302604964.2139.5.camel@alex-2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1302604964.2139.5.camel@alex-2>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 12, 2011 at 12:42:44PM +0200, Alexander Simon wrote:
> Needed for IBSS IEEE802.11N operation
> 
> * Add ht channel type for cfg80211 IBSS configuration
> 
> Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>

Are you going to resubmit this series after addressing Johannes's comments?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
