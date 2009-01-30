Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:60704 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbZA3Orr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 09:47:47 -0500
Received: by rv-out-0506.google.com with SMTP id k40so467849rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 06:47:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <40f31dec0901300017g2504e494mc75db9d9a0ffca7@mail.gmail.com>
References: <498269D5.7080204@openwrt.org>
	 <40f31dec0901300017g2504e494mc75db9d9a0ffca7@mail.gmail.com>
Date: Fri, 30 Jan 2009 09:47:46 -0500
Message-ID: <b6c5339f0901300647y69bda19bq9c749b1c42334398@mail.gmail.com> (sfid-20090130_154752_228515_B46B1B45)
Subject: Re: [PATCH,RFC 0/2] ath5k: implement tx power calibration on
	ar2413/5413
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 30, 2009 at 3:17 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> I'm sending some patches that update phy.c, initvals.c and reset.c etc
> today and i'll merge this one with RF5111/RF5112 pcdac stuff and tpc
> support asap to have power table support for all chips. We also need
> to work out regulatory stuff before we fully enable tx power support
> so i have to test this on a spectrum analyzer.

Speaking of regulatory, I had started adding the 802.11d stuff from
ath9k already, but I haven't gotten to the point of even compiling it
yet.  Want me to continue on it?  Probably can have something to show
this weekend.

-- 
Bob Copeland %% www.bobcopeland.com
