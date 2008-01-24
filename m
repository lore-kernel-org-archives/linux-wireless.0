Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37025 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757464AbYAXVfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 16:35:47 -0500
Date: Thu, 24 Jan 2008 13:34:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <20080124210728.GD3200@tuxdriver.com>
Message-ID: <alpine.LFD.1.00.0801241334010.7482@hp.linux-foundation.org> (sfid-20080124_213551_947160_3434D67B)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801071830.51895.mb@bu3sch.de> <20080107212344.1372cc47@Varda> <200801081630.31110.mb@bu3sch.de> <alpine.LFD.1.00.0801241224050.2803@woody.linux-foundation.org>
 <20080124210728.GD3200@tuxdriver.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Thu, 24 Jan 2008, John W. Linville wrote:
> 
> There is no great harm in reverting
> 81100eb80add328c4d2a377326f15aa0e7236398 if you would like to go ahead
> and push the 2.6.24 release.  I suspect, however, that the mac80211
> guys would like to keep it (or put it back for 2.6.25) to continue
> to shame driver developers in the future.

I'd be happy to have it back in the development tree, I just don't want to 
have the noise for a release tree.

Will revert that commit with a comment to that effect. Thanks,

		Linus
