Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2454 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030424AbXBOSIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 13:08:10 -0500
Date: Thu, 15 Feb 2007 12:41:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] d80211: Add software sequence support
Message-ID: <20070215174143.GA6300@tuxdriver.com>
References: <200702141423.27823.IvDoorn@gmail.com> <1171557724.5220.30.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1171557724.5220.30.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 15, 2007 at 05:42:04PM +0100, Johannes Berg wrote:

> Then the driver can just call it whenever it needs the sequence number
> for a frame. It'll need to be a bit smart about fragmentation but I
> think that's ok.
> 
> I may be radical, but I think that a lot of things hardware can do
> belong into library functions the driver can use instead of cluttering
> the stack with it.

I'm inclined to agree, FWIW...

-- 
John W. Linville
linville@tuxdriver.com
