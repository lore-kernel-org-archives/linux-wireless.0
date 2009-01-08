Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:40278 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZAHFUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 00:20:50 -0500
Received: by bwz14 with SMTP id 14so26758320bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 21:20:48 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: localversion-wireless missing from wireless-testing
References: <877i59q97f.fsf@litku.valot.fi>
	<20090107205618.GB4387@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 08 Jan 2009 07:20:45 +0200
In-Reply-To: <20090107205618.GB4387@tuxdriver.com> (John W. Linville's message of "Wed\, 7 Jan 2009 15\:56\:18 -0500")
Message-ID: <87ljtmcr0y.fsf@litku.valot.fi> (sfid-20090108_062056_349897_77DA6F15)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> On Tue, Jan 06, 2009 at 07:45:08AM +0200, Kalle Valo wrote:
>
>> I noticed that after 2.6.28 update localversion-wireless file is
>> missing from wireless-testing and version doesn't contain -wl suffix
>> anymore.
>
> Yes, sorry -- not sure what happened.  Anyway, it is there today.

Yes, it's working now:

Linux tikku 2.6.28-wl #111 SMP Wed Jan 7 11:07:11 EET 2009 i686 GNU/Linux

Thanks for fixing it.

-- 
Kalle Valo
