Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:38967 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYLWPDX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 10:03:23 -0500
Message-ID: <20081223100342.g4qepcdkv4kg0ss4-cebfxv@webmail.spamcop.net> (sfid-20081223_160326_484009_1AF4D22A)
Date: Tue, 23 Dec 2008 10:03:42 -0500
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Davide Pesavento <davidepesa@gmail.com>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] crda: use strerror() to report error code verbosely
References: <20081223050006.3710.98311.stgit@ct.roinet.com>
	<43e72e890812222127k60ade0f1u21263800f9374f52@mail.gmail.com>
	<20081223004945.3437vudqtc0ogcsk-cebfxv@webmail.spamcop.net>
	<43e72e890812222157s5d410d39ye9ac0840eef5331a@mail.gmail.com>
	<20081223012037.otw1xe4tc084coc8-cebfxv@webmail.spamcop.net>
	<2da21fe50812230041q1d844215o589c79c351966e50@mail.gmail.com>
	<20081223094138.jlokt6sr40w448o0-cebfxv@webmail.spamcop.net>
	<43e72e890812230657w58dd2f9an5d1bf7e7a824ff57@mail.gmail.com>
In-Reply-To: <43e72e890812230657w58dd2f9an5d1bf7e7a824ff57@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:

>>  It
>> should only run by the kernel through udev.  If that is correct, it should
>> be written clearly in the crda README.
>
> Apologies if it is not clear. How's this:
>
> ---
>  CALLING CRDA -- UDEV
> ======================
>
> Distributions

...  I'm not a distribution.  Skipping to the next paragraph.  :-)

> Or the giant diagram here:
>
> http://wireless.kernel.org/en/developers/Regulatory

Thanks.

> The wiki is editable by everyone so feel free to update that, and also
> feel free to send patches to the README as you see fit.

Will do.  Sorry for the noise.

-- 
Regards,
Pavel Roskin
