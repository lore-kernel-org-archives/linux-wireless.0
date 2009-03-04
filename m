Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:57973 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbZCDKEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 05:04:48 -0500
Received: by bwz26 with SMTP id 26so2732169bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2009 02:04:44 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Mike Cui <cuicui@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Bug in iw prevents setting the "cook" monitor flag
References: <7c8826910903021516t640aa84dxfbb61a278b69c740@mail.gmail.com>
	<20090303145233.GB17678@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 04 Mar 2009 12:04:39 +0200
In-Reply-To: <20090303145233.GB17678@tuxdriver.com> (John W. Linville's message of "Tue\, 3 Mar 2009 09\:52\:33 -0500")
Message-ID: <87tz69six4.fsf@litku.valot.fi> (sfid-20090304_110453_358663_E3CD1BBB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> On Mon, Mar 02, 2009 at 03:16:14PM -0800, Mike Cui wrote:
>> There is an off by one error in interface.c of iw that prevents
>> passing of the cook flag when creating a monitor interface. The fix is
>> simple:
>> 
>> 
>> --- a/interface.c       2009-03-02 15:11:58.748078548 -0800
>> +++ b/interface.c       2009-03-02 15:12:14.695203787 -0800

[...]

> FWIW, I think I like "x <= Y" instead of "x < Y + 1".

I agree.

> Also, please make sure you are following the guidelines explained here:
>
> 	http://linux.yyz.us/patch-format.html
>
> In particular, I need a Signed-off-by line from you.

But this is for iw, not for wireless-testing. Or did I miss something?

-- 
Kalle Valo
