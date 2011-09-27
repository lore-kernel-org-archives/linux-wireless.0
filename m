Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:34096 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395Ab1I0F2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 01:28:15 -0400
Received: by bkbzt19 with SMTP id zt19so6224363bkb.9
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 22:28:11 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Add support for HW channel switch
From: Luciano Coelho <coelho@ti.com>
To: victorg@ti.com
Cc: "Levi, Shahar" <shahar_levi@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <4E80286C.8090801@ti.com>
References: <1315476093-27583-1-git-send-email-shahar_levi@ti.com>
	 <1316698619.2157.628.camel@cumari> <1316775583.2157.728.camel@cumari>
	 <CAHiDVwkeMTYdVubk=YPp6XTfNtmr2+mTwuX-ED0TcmzmrvEfUw@mail.gmail.com>
	 <1317018322.2171.17.camel@cumari>  <4E80286C.8090801@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 08:28:07 +0300
Message-ID: <1317101287.2171.81.camel@cumari> (sfid-20110927_072819_036108_5ADB12DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-26 at 10:23 +0300, Victor Goldenshtein wrote: 
> On 26/09/2011 09:25, Luciano Coelho wrote:
> >>> I checked this a bit further and I don't see the point in sending all
> >>> packets here.  In fact, if block_tx is set, we can't even send any more
> >>> frames until the switch happens (or fails).  So we should at least check
> >>> this here.
> >> The block_tx is taken into account in the mac layer.
> >
> > This is a bit strange, though.  I checked the code and nobody seems to
> > be using the block_tx element of ieee80211_channel_switch, so I wonder
> > why it's there at all.
> >
> 
> As far as I know the block_tx is for the DFS channel switch 
> implementation, when block_tx=1, the firmware will not start tx on new 
> channel.

I'll check this up with our firmware team.

-- 
Cheers,
Luca.

