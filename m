Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2FMGNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 02:13:38 -0400
Message-ID: <1339568015.4519.5.camel@jlt3.sipsolutions.net> (sfid-20120613_081412_126044_06DA1191)
Subject: Re: iwlwifi updates for 3.6
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Jun 2012 08:13:35 +0200
In-Reply-To: <1339531055.4531.21.camel@jlt3.sipsolutions.net> (sfid-20120612_215743_461598_2A44FF39)
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120611_115334_801449_87F3D667) <1339531055.4531.21.camel@jlt3.sipsolutions.net>
	 (sfid-20120612_215743_461598_2A44FF39)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 21:57 +0200, Johannes Berg wrote:
> John,
> 
> please pull the iwlwifi-next tree.
> 
> I've included the patches here, in slightly fixed up versions, a small
> additional warning that we need to flag/debug some issues, and also of
> course the fix for the EEPROM refactoring vs. addition of the separate
> configuration structure for 6035 devices.
> 
> The patches I posted previously included a few fixes for code that went
> into the tree in my last pull and more debugging utilities.

Please hold off. We found a crash when firmware is missing due to one of
the patches here (that fix something else unfortunately) -- I'll roll in
the fix and rebuild the pull request today.

johannes

