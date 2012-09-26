Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:38347 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab2IZRGv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 13:06:51 -0400
From: Kalle Valo <kvalo@adurom.com>
To: kiranaab ki <kiranaab@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: Re: Which tree to pull for submitting patches to net/mac80211
References: <CACuskh++j1QPgvBNhpGmhUOjwozk2vybHq=3_-iSoWaAVxkEvw@mail.gmail.com>
Date: Wed, 26 Sep 2012 20:06:44 +0300
In-Reply-To: <CACuskh++j1QPgvBNhpGmhUOjwozk2vybHq=3_-iSoWaAVxkEvw@mail.gmail.com>
	(kiranaab ki's message of "Wed, 26 Sep 2012 21:51:56 +0530")
Message-ID: <87k3vg3e8r.fsf@purkki.adurom.net> (sfid-20120926_190654_965449_3E9050AE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kiranaab ki <kiranaab@gmail.com> writes:

> I also see in MAINTAINERS list that Johannes Berg maintains two trees
>    mac80211.git,
>    mac80211-next.git
>
> If I want to send the patches for net/mac80211 and net/cfg8011
> do I need to pull wireless-testing.git and send the patches so that
> John W Linwille reviews them
>
>      or
>
> do I need to pull mac80211-next.git and send the patches so that
> Johannes Berg will review the patches and later John W Linville
> pulls the changes from Johannes's tree along the development process ?

For new people in the Linux development I would recommend to use
wireless-testing and submit patches to the linux-wireless mailing, just
to keep things simple. Johannes when picks up the patch whenever he has
time.

In rare occasions your patch might conflict with something which is in
mac80211-next and Johannes might ask you to rebase your patch. But this
usually happens when making more extensive changes to mac80211, for
smaller patches this is really rare.

-- 
Kalle Valo
