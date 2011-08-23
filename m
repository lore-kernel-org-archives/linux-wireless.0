Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40111 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab1HWTpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 15:45:14 -0400
Date: Tue, 23 Aug 2011 15:39:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] nl80211: Parse channel type attribute in an IBSS
 join request
Message-ID: <20110823193939.GE9770@tuxdriver.com> (sfid-20110823_214519_850135_4E5AA09D)
References: <1888623.Vt5VZUN2cU@alex-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1888623.Vt5VZUN2cU@alex-1>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 08, 2011 at 02:02:58PM +0200, Alexander Simon wrote:
> Check if the requested HT mode can be used.
> Extend cfg80211 IBSS struct for HT mode.
> 
> Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>
> ---
> 
> As there were no replies for my RFC post, i am resending this as PATCH.

This series got a lot of comments.  Are you planning to post a
revised series?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
