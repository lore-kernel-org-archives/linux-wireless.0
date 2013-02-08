Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60773 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760255Ab3BHUgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 15:36:10 -0500
Message-ID: <1360355765.29851.29.camel@jlt4.sipsolutions.net> (sfid-20130208_215344_897365_4D12C76F)
Subject: Re: RFCv4: ST-E CW1100/1200 WLAN driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 08 Feb 2013 21:36:05 +0100
In-Reply-To: <1360355527-12159-1-git-send-email-pizza@shaftnet.org> (sfid-20130208_213359_062625_8A890FCA)
References: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
	 (sfid-20130208_213359_062625_8A890FCA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 15:31 -0500, Solomon Peachy wrote:

> There are still a couple bits of code present for older (<2.6.36 and <3.2) 
> kernels, which I will strip out for inclusion in compat-drivers once 
> this is mainlined.  (Is there a better process I should follow here?)

You should probably just submit it without those bits for the
wireless-next tree and then to the relevant compat-drivers patches as
needed.

johannes

