Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.238]:24803 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbXLJBHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 20:07:30 -0500
Received: by wr-out-0506.google.com with SMTP id c49so1144085wra
        for <linux-wireless@vger.kernel.org>; Sun, 09 Dec 2007 17:07:27 -0800 (PST)
Message-ID: <a8e1da0712091707ve2edf0el7103b66ae28b58@mail.gmail.com> (sfid-20071210_010734_474817_FCC1DE4B)
Date: Mon, 10 Dec 2007 09:07:27 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Subject: Re: 2.6.24-rc4-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <43e72e890712071422j34ca2338xf98fda661f3c22fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	 <20071207021258.GA12624@darkstar.lan>
	 <43e72e890712071422j34ca2338xf98fda661f3c22fc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 8, 2007 6:22 AM, Luis R. Rodriguez <mcgrof@winlab.rutgers.edu> wrote:
> On Dec 6, 2007 9:12 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > Hi,
> >
> > 2.6.24-rc4-mm1 build failed at drivers/net/wireless/ath5k/base.c for some inline functions like this:
> > drivers/net/wireless/ath5k/base.c:292: sorry, unimplemented: inlining failed in call to 'ath5k_extend_tsf': function body not available
> >
> > fix it with adjust the order of inline function body.
> >
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

Thanks.

>
> Thanks Dave. What version of gcc were you using? I haven't run into this.

gcc 3.4.6

>
> BTW, nothing new was added in this patch, things were just shifted,
> but even that may be copyrightable. Is it fair to assume you are
> licensing these changes under the same license the file is in?

Ok, I don't care.

>
> For this file we'd usually use:
>
> Changes-licensed-under: 3-clause-BSD
>
> For future reference:
>
> http://linuxwireless.org/en/developers/Documentation/SubmittingPatches#Changes-licensed-undertag
>
>   Luis
>
