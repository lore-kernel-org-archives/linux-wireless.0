Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:38924 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423269AbXBHTow (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 14:44:52 -0500
Date: Thu, 8 Feb 2007 20:44:47 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <jkmaline@cc.hut.fi>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH #2] d80211: Add API to generate RTS and CTS-to-self  frames
Message-ID: <20070208204447.74fbd37a@griffin.suse.cz>
In-Reply-To: <200702051726.09556.mb@bu3sch.de>
References: <200702051726.09556.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 5 Feb 2007 17:26:09 +0100, Michael Buesch wrote:
> This adds API calls to generate RTS and CTS-to-self frames.
> To be called if the device firmware requires the host to
> generate RTS/CTS frames.

Applied to my tree, thanks for the patch.

 Jiri

-- 
Jiri Benc
SUSE Labs
