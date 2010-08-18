Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:59597 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab0HRPtB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 11:49:01 -0400
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH 0/4] wl1271 -> wl1251 port patches
References: <1282074415-6168-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 18 Aug 2010 18:48:57 +0300
In-Reply-To: <1282074415-6168-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Tue\, 17 Aug 2010 22\:46\:51 +0300")
Message-ID: <87sk2b9b12.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> Hi,

Hi Grazvydas,

> I've been looking at wl1271 changelog and found several patches that
> seem to be also applicable to wl1251. I'm not that sure about patches
> 2 and 4, but 1 and 3 should be correct (I've verified 3 with TI driver).
> I've been running these on pandora for several days now without problems.

Patches looked good, thank you for them.

> It's a shame wl12xx drivers were completely split, it would look like
> they could share fair bit of code. Now wl1251 does not benefit from more
> actively developed wl1271 fixes.

We tried that first. But there were so many subtle differences
everywhere that it became very difficult to handle and we decided to
split the driver. Of course that also has it's problems like you
mentioned. A stable firmware API would have solved this, but as usual
when dealing with hardware, it's just a pipe dream.

> There are even more wl1271 patches that could be applicable to wl1251.
> Kalle, could you take a look at the list below? I could try porting if
> you think any of those make sense.

Sorry, I can't do it right now but I should have time for it later
this week.

-- 
Kalle Valo
