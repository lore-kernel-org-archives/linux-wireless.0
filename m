Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:47383 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZHJSva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 14:51:30 -0400
Received: by pzk34 with SMTP id 34so3016656pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 11:51:31 -0700 (PDT)
Message-ID: <4A806C2F.9070206@lwfinger.net>
Date: Mon, 10 Aug 2009 13:51:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Implement LP-PHY baseband table initialization
References: <4A806973.1020109@gmail.com>
In-Reply-To: <4A806973.1020109@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> Implement LP-PHY baseband table init for all revisions.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> Changes from RFC:
> -Improved table formatting in the code.
> -The 2GHz check in adjust_gain_table now uses b43_current_band.
> -Added a comment to rev2plus_table_init about a possible future
> improvement.

I like the new table formatting.

The comment in rev2plus_table_init has a typo - "ben" should be
"been". Otherwise it looks good. Thanks for all your work.

Larry
