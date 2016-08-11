Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52794 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932533AbcHKM4C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 08:56:02 -0400
Message-ID: <1470920143.12075.10.camel@sipsolutions.net> (sfid-20160811_145605_820027_E053A517)
Subject: Re: [PATCH] mac80211: Add protection to get_expected_throughput
 opcode
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Altshul <maxim.altshul@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Aug 2016 14:55:43 +0200
In-Reply-To: <20160811103816.1695-2-maxim.altshul@ti.com>
References: <20160811103816.1695-1-maxim.altshul@ti.com>
	 <20160811103816.1695-2-maxim.altshul@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-08-11 at 13:38 +0300, Maxim Altshul wrote:
> To protect the opcode we add a check for sta->uploaded.
> 
Applied, with a reworded commit message - thanks

johannes
