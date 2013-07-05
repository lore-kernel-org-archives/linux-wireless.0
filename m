Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3GEHPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 03:15:24 -0400
Message-ID: <1373008522.8548.1.camel@jlt4.sipsolutions.net> (sfid-20130705_091526_949943_9B6FE124)
Subject: Re: [PATCH] mac80211: Handle zero RTS threshold
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 05 Jul 2013 09:15:22 +0200
In-Reply-To: <1373003143-29211-1-git-send-email-sujith@msujith.org>
References: <1373003143-29211-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-05 at 11:15 +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> The spec says:
> 
> "Setting this attribute to 0 has the effect of turning on the RTS/CTS
> handshake for all frames of Data or Management type transmitted by this
> STA."

Maybe we should set it to 0xffffffff in cfg80211 to make it simpler for
drivers?

johannes

