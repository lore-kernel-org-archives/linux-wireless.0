Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47300 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933148AbXBWQzN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 11:55:13 -0500
Date: Fri, 23 Feb 2007 17:55:11 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] d80211: convert to use compare_ether_addr
Message-ID: <20070223175511.69c308a9@griffin.suse.cz>
In-Reply-To: <20070222161210.270f2905@freekitty>
References: <20070222161014.62d064a6@freekitty>
	<20070222161210.270f2905@freekitty>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 22 Feb 2007 16:12:10 -0800, Stephen Hemminger wrote:
> compare_ether_addr is faster than memcmp()

Applied 1 and 3. 2 is already fixed in the latest wireless-dev.

Thanks for the patches,

 Jiri

-- 
Jiri Benc
SUSE Labs
