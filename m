Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:46502 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbYJTWjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 18:39:22 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2088770rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 15:39:21 -0700 (PDT)
Message-ID: <2da21fe50810201539k74dedcfbwf4d63827e10e6c40@mail.gmail.com> (sfid-20081021_003927_845105_0C1F6038)
Date: Tue, 21 Oct 2008 00:39:21 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: crda packaging
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890810201515k79ad4e3cj90643ad853e3acfe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2da21fe50810190857j4dacb612u3a2bba4ab3baa7fd@mail.gmail.com>
	 <43e72e890810191828x44624d4fsa8d56170d2ba4f46@mail.gmail.com>
	 <2da21fe50810201336r29ed4e83g18d57e6d01b97349@mail.gmail.com>
	 <20081020140438.GD9035@tesla>
	 <2da21fe50810201448y6f05770at1d611d5a9ddc7e5b@mail.gmail.com>
	 <43e72e890810201515k79ad4e3cj90643ad853e3acfe@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/21 Luis R. Rodriguez <lrodriguez@atheros.com>:
> On Mon, Oct 20, 2008 at 2:48 PM, Davide Pesavento <davidepesa@gmail.com> wrote:
>
>> Ah, right. This is the point I forgot, thanks for your explanation.
>> This is not a problem for Gentoo ebuilds; I guess it isn't for other
>> distros as well.
>
> Ah you do the gentoo packaging?
>

That's the idea. I'm not a gentoo developer (not yet at least), but I
can write an ebuild and submit it for inclusion into portage.
Do you need any other help?

>>>> (4) When the regulatory database is updated, John releases a new
>>>> version by "compiling" and signing it again.
>
> BTW -- the reason I mentioned a separate git tree for db.txt is so
> that we can handle releases of crda and the binary db separately.
>

Yeah, of course. This is the best solution I think.

Davide
