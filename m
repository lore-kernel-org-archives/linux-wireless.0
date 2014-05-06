Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbaEFNIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 09:08:40 -0400
Message-ID: <1399381710.4218.26.camel@jlt4.sipsolutions.net> (sfid-20140506_150845_037694_48B09A66)
Subject: Re: [PATCH 1/4] cfg80211/nl80211: add channel switch started and
 failed notifications
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ilan Peer <ilan.peer@intel.com>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Tue, 06 May 2014 15:08:30 +0200
In-Reply-To: <CA+BoTQmQ-2MeWO3FkKPxo3XyUjQ4X2LAA2uOuYLzASRydF6+LQ@mail.gmail.com> (sfid-20140506_144931_550819_743E42C5)
References: <1399038031-23206-1-git-send-email-luca@coelho.fi>
	 <1399373244.4218.21.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmQ-2MeWO3FkKPxo3XyUjQ4X2LAA2uOuYLzASRydF6+LQ@mail.gmail.com>
	 (sfid-20140506_144931_550819_743E42C5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-06 at 14:49 +0200, Michal Kazior wrote:
> > (I seem to remember a fix in this area but can't seem to find
> > it in my tree!!)
> 
> Just a reminder - there's my pending patchset (mac80211/cfg80211: CSA
> fixes/cleanups) for CSA that disconnects interfaces that fail to
> switch channel. Perhaps I should re-post?

D'oh. No, I have it, I'll pick it up. I just forgot - there was some
minor thing with it and I thought Luca might pick it up, so I dropped
it. I'll go look at it now.

johannes

