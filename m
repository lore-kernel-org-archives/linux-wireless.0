Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34724 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030689AbXBOTLJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 14:11:09 -0500
Date: Thu, 15 Feb 2007 20:11:07 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] d80211: Add software sequence support
Message-ID: <20070215201107.46e4344f@griffin.suse.cz>
In-Reply-To: <200702151402.48150.flamingice@sourmilk.net>
References: <200702141423.27823.IvDoorn@gmail.com>
	<1171557724.5220.30.camel@johannes.berg>
	<200702151402.48150.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 15 Feb 2007 14:02:43 -0500, Michael Wu wrote:
> If we're going to switch to a library approach, let's do it all at once. I 
> don't want some features requiring flags to toggle and others requiring a 
> function to call.

Entirely library approach is not possible. So we're going to end up
with mixed environment in any case.

 Jiri

-- 
Jiri Benc
SUSE Labs
