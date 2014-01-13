Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45277 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaAMTH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 14:07:59 -0500
Message-ID: <1389640062.5008.14.camel@jlt4.sipsolutions.net> (sfid-20140113_200803_340625_0F2EE18D)
Subject: Re: [PATCH v5] wl12xx: fix tx power setting
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Gal <a.gal@motsai.com>
Cc: Luca Coelho <luca@coelho.fi>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 13 Jan 2014 20:07:42 +0100
In-Reply-To: <CAN44aq2CAuF=Yx3YUvesagxSod=rNHq0sV98jeTQFoY1tHhFRg@mail.gmail.com> (sfid-20140113_200454_104775_856FB94E)
References: <1389385273-1322-1-git-send-email-a.gal@motsai.com>
	 <1389620141.5008.8.camel@jlt4.sipsolutions.net>
	 <CAN44aq1hrya4B4X4xTi4Aphb9QDBiQ9813kT6vhxtDCzBRoNhQ@mail.gmail.com>
	 <1389633805.5008.13.camel@jlt4.sipsolutions.net>
	 <CAN44aq2CAuF=Yx3YUvesagxSod=rNHq0sV98jeTQFoY1tHhFRg@mail.gmail.com>
	 (sfid-20140113_200454_104775_856FB94E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-13 at 14:04 -0500, Alex Gal wrote:
> > Oh, really? Ok. I didn't think that driver supported channel contexts.
> > In that case your patch is right but incomplete - you should remove the
> > CONF_CHANGE_POWER handling.
> 
> I think wlcore is used by both wl12xx and wl18xx.
> 
> It looks like wl18xx supports multiple channels and perhaps channel
> contexts (?) while the wl12xx does not.

So maybe you would still need both.

johannes

