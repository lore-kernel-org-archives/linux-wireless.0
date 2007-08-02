Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41813
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbXHBJkz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 05:40:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [PATCH] ssb-chipcommon: Add function to get processor clock
Date: Thu, 2 Aug 2007 11:40:25 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
References: <200708010011.56753.mb@bu3sch.de> <200708020009.50374.mb@bu3sch.de> <46B19FFE.2010900@aurel32.net>
In-Reply-To: <46B19FFE.2010900@aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708021140.25676.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 02 August 2007 11:12:30 Aurelien Jarno wrote:
> Yep the merge of the bcm47xx is on my TODO list, but I want to finish
> the SSB parts first. I hope to finish that before the end of this week-end.
> 
> About the bcm47xx arch code, my plan is to merge first a very simple
> version that allow the machine to boot, but without support for CFE.
> 

There are also mipscore patches in openwrt that need to get merged upstream.
Do you take care of these, too?

-- 
Greetings Michael.
