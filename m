Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:61431 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760658AbXK2NKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 08:10:41 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1537060rvb
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2007 05:10:40 -0800 (PST)
Message-ID: <43e72e890711290510m7c1dff15jf7e0e8f5b6166921@mail.gmail.com> (sfid-20071129_131043_502298_D3C9D0E5)
Date: Thu, 29 Nov 2007 08:10:40 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Subject: Re: [BUG] libertas: probing for Marvell USB8388 fails
Cc: linux-wireless@vger.kernel.org,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	"Dan Williams" <dcbw@redhat.com>
In-Reply-To: <200711291020.31946.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071117023548.79a7a33c@morte>
	 <1195502746.6479.11.camel@localhost.localdomain>
	 <20071119213123.084d40f7@morte>
	 <200711291020.31946.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 29, 2007 4:20 AM, Holger Schurig <hs4233@mail.mn-solutions.de> wrote:
> > > Which branch of wireless-2.6 are you running?  What kernel
> > > version?
> >
> > Branch everything, head:
> > 1efded8eb6a7554748ca9486a9902fa6e86ff4a7.
>
> I can't find this.
>
> $ git clone --reference /usr/src/linux-git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
> $ cd wireless-2.6; git checkout -b everything origin/everything
> $ git show 1efded8eb6a7554748ca9486a9902fa6e86ff4a7
> fatal: bad object 1efded8eb6a7554748ca9486a9902fa6e86ff4a7
>
> My head is
>
> $ git log | head -1
> commit 301df40749bdf144c72637795ba93d82e4b84682

That is indeed the latest SHA for #everything. Anyway the SHA on each
commit changes upon rebase. It seems this is what happened. You're
probably better off checking based on date. I believe Stefano's issues
are the same ones as the one I reported. Would it have to do with the
old bcdVersion? Does the device need its firmware upgraded first? If
so how do we do this?

  Luis
