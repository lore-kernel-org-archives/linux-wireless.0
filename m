Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39229 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab1FBTOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 15:14:37 -0400
Subject: Re: [PATCH v2] wireless: Support can-scan-one logic.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTinozbG2SfOCRd1U__8-Pz9-8HCkPQ@mail.gmail.com> (sfid-20110602_211238_294668_E3CAACEF)
References: <1305586296-23147-1-git-send-email-greearb@candelatech.com>
	 <1305759738.8827.6.camel@jlt3.sipsolutions.net>
	 <4DD4569C.7080303@candelatech.com>
	 <BANLkTinozbG2SfOCRd1U__8-Pz9-8HCkPQ@mail.gmail.com>
	 (sfid-20110602_211238_294668_E3CAACEF)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 21:14:32 +0200
Message-ID: <1307042072.3738.4.camel@jlt3.sipsolutions.net> (sfid-20110602_211440_394128_6F286991)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-02 at 12:12 -0700, Luis R. Rodriguez wrote:

> Since this shit was merged can you add a respective documentation
> extension for the command for nl80211.h?

You're kidding, right? The -1 crap was merged? Breaking all drivers
other than mac80211?

johannes

