Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41039 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2KFMW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 07:22:59 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TViBF-0005fl-Sf
	for linux-wireless@vger.kernel.org; Tue, 06 Nov 2012 13:22:58 +0100
Message-ID: <1352204615.9440.9.camel@jlt4.sipsolutions.net> (sfid-20121106_132310_718208_5D9AAE23)
Subject: Re: [PATCH 0/2] mac80211: client-side P2P powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 06 Nov 2012 13:23:35 +0100
In-Reply-To: <1352126445-25088-1-git-send-email-johannes@sipsolutions.net> (sfid-20121105_154021_900032_74F25FFB)
References: <1352126445-25088-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121105_154021_900032_74F25FFB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-05 at 15:40 +0100, Johannes Berg wrote:
> Implement passing the P2P powersave parameters (except NoA
> schedules) to the mac80211 hardware driver. To do this, I
> introduced a generic function to get a copy of some P2P
> attribute into a buffer, I did it that way because of the
> potential for fragmentation into multiple IEs.
> 
> The only change over the RFC is that I now use the correct
> attribute ID definition from Arend's patch.

Applied both.

johannes

