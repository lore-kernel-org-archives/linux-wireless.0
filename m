Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58019 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1KNFnZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 00:43:25 -0500
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rewriting powersave
References: <1320929045.3967.52.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 14 Nov 2011 07:43:23 +0200
In-Reply-To: <1320929045.3967.52.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Thu\, 10 Nov 2011 13\:44\:05 +0100")
Message-ID: <8739dr9s3o.fsf@purkki.adurom.net> (sfid-20111114_064328_504819_32048CA2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Johannes Berg <johannes@sipsolutions.net> writes:

> Since clearly it is possible to implement this in the lower layers, I'm
> thinking we should provide an implementation that the drivers can use to
> implement powersave and be in category 4 from mac80211's POV.

I think this is the way to go, even I was skeptic when you first
mentioned about. We really need to make mac80211 powersave
implementation more simple and this is a clean way to do it. And I
would assume that all new (sane) hardware designs belong to category 4
so this would only affect existing drivers.

-- 
Kalle Valo
