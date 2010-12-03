Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38391 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab0LCWXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 17:23:06 -0500
Received: by qyk11 with SMTP id 11so1392617qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Dec 2010 14:23:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101203145558.GA2348@tuxdriver.com>
References: <20101203040300.GA2988@makis.mantri>
	<20101203145558.GA2348@tuxdriver.com>
Date: Fri, 3 Dec 2010 17:23:05 -0500
Message-ID: <AANLkTi=iixqOgRhgGwwuz+oVzO78yXZ7C=Y8uX+3M_VZ@mail.gmail.com>
Subject: Re: [PATCH 1/6] ath5k: Always write tx powertable on hw
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	mcgrof@gmail.com, jirislaby@gmail.com, nbd@openwrt.org,
	br1@einfach.org, sedat.dilek@googlemail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 3, 2010 at 9:55 AM, John W. Linville <linville@tuxdriver.com> wrote:
> On Fri, Dec 03, 2010 at 06:03:00AM +0200, Nick Kossifidis wrote:
>>  * By skipping tx power table calibration we also skip setting
>>  tx power table on hw. Make sure we always write tx power table
>>  on hw since it gets cleared on reset.
>>
>>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> Hey, Nick -- just a process note...
>
> All your patches have " Signed-off-by..." (notice the leading space),
> which looks a bit funny.  Could you figure-out why this is happening
> and change it to remove the leading space?

Also the "*" thing is a bit weird as kernel commit messages go.

-- 
Bob Copeland %% www.bobcopeland.com
