Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2750 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbXLMV6Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 16:58:25 -0500
Date: Thu, 13 Dec 2007 16:31:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bjorge Dijkstra <bjd@jooz.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: status wireless extensions API for new drivers
Message-ID: <20071213213118.GE3083@tuxdriver.com> (sfid-20071213_215828_482877_D0A795A3)
References: <4761A108.2080005@jooz.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4761A108.2080005@jooz.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 13, 2007 at 10:15:52PM +0100, Bjorge Dijkstra wrote:

> We have used the Wireless Extensions API, but I get the impression that
> things are moving towards the cfg/nl80211 API's. Is it still acceptable
> for new drivers trying to get into mainline to use WEXT, or should we
> switch to the new API's?

WEXT is fine for new drivers.  At this time cfg80211 does not offer
a suitable replacement.

John
-- 
John W. Linville
linville@tuxdriver.com
