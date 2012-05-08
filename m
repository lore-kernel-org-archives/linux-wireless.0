Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45196 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2EHRzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 13:55:53 -0400
Received: by yenm10 with SMTP id m10so5106726yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 10:55:52 -0700 (PDT)
Date: Tue, 8 May 2012 13:55:36 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Vadim <Vadims.Kurmis@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Adding custom channels to ath5k for researching purposes
Message-ID: <20120508175536.GF25400@localhost> (sfid-20120508_195556_774661_4EE0BD1E)
References: <loom.20101104T140201-178@post.gmane.org>
 <AANLkTinMSH2Vr=iUTD0Pc_OdaM_LFETDEjsOJn+2ZzVD@mail.gmail.com>
 <CAB=NE6X=iD7Hh7-wFx8-ZudNWUKKJw1Mg5MC_G3z4knu7bNTqg@mail.gmail.com>
 <20120508163018.GE25400@localhost>
 <CAB=NE6Xx_KKjk5s_CMRopwBuHDxajgn=Jdc_Nbb1DN2s=2QL0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6Xx_KKjk5s_CMRopwBuHDxajgn=Jdc_Nbb1DN2s=2QL0A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 08, 2012 at 09:49:22AM -0700, Luis R. Rodriguez wrote:
> > I still like the idea of exporting more stuff to userspace and letting
> > CRDA handle the card-based restrictions, but ISTR you had reasons that
> > didn't work for everything.
> 
> What do you mean?

/me digs in the archives...

http://marc.info/?l=linux-wireless&m=125752855010045&w=2

I guess I "still" liked it back then :)

So with that setup people who want to fiddle with the card in 'expert'
mode could override the card's eeprom reg domain stuff by suitably
changing crda db instead of recompiling the kernel.

But if I read your follow-ups correctly, going that way wasn't actually
a big win.  I didn't then (much less now) have the time to explore it
in actual code.

That doesn't cover the person who wanted to use all_channels, but at
least that is exported by a modparam today.  There are probably other
things that an 'expert' would want to do beyond these two, though.

-- 
Bob Copeland %% www.bobcopeland.com
