Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36698 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbbIBS2J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 14:28:09 -0400
Message-ID: <1441218485.2565.4.camel@sipsolutions.net> (sfid-20150902_202813_553056_C9353B83)
Subject: Re: [PATCH] rfkill: Copy "all" global state to other types
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Date: Wed, 02 Sep 2015 20:28:05 +0200
In-Reply-To: <87B673AF-9598-42D6-B77E-1F2F08A579FC@holtmann.org>
References: <1440462512.2670.83.camel@perches.com>
	 <1440507403-9695-1-git-send-email-jprvita@endlessm.com>
	 <4CA6A223-16CD-4A0F-A671-6B4BB026CB82@holtmann.org>
	 <CA+A7VXVwmDEboDq-nACJH2n-UquTkO1i-+xgEm32OD5EDVfQfg@mail.gmail.com>
	 <87B673AF-9598-42D6-B77E-1F2F08A579FC@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-02 at 10:42 -0700, Marcel Holtmann wrote:
> 
> > Any feedback or any plans to pick this for mac80211-next (which I
> > understand is where it should go to be sent upstream)?
> 
> I can take this through bluetooth-next tree if there are no 
> objections.
> 

I'm going to to take it, but we're in the middle of release/merge
-window time, so there was no point in doing that just yet.

johannes
