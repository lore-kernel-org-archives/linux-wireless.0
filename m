Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38678 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab2EHQto convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 12:49:44 -0400
Received: by yhmm54 with SMTP id m54so5522266yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 09:49:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120508163018.GE25400@localhost>
References: <loom.20101104T140201-178@post.gmane.org> <AANLkTinMSH2Vr=iUTD0Pc_OdaM_LFETDEjsOJn+2ZzVD@mail.gmail.com>
 <CAB=NE6X=iD7Hh7-wFx8-ZudNWUKKJw1Mg5MC_G3z4knu7bNTqg@mail.gmail.com> <20120508163018.GE25400@localhost>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 8 May 2012 09:49:22 -0700
Message-ID: <CAB=NE6Xx_KKjk5s_CMRopwBuHDxajgn=Jdc_Nbb1DN2s=2QL0A@mail.gmail.com> (sfid-20120508_184947_661526_2481DFE1)
Subject: Re: Adding custom channels to ath5k for researching purposes
To: Bob Copeland <me@bobcopeland.com>
Cc: Vadim <Vadims.Kurmis@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 8, 2012 at 9:30 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, May 08, 2012 at 07:50:06AM -0700, Luis R. Rodriguez wrote:
>> I'm thinking it may make sense to add CONFIG_WIRELESS_EXPERT where we
>> can stuff some of this stuff under. It may be useful for other
>> regulatory testing / certification stuff.
>
> No objection here, so long as this kind of config opt wouldn't become
> a dumping ground (cf. CONFIG_EMBEDDED).  "EXPERT" could mean different
> things to different people.

Well it should depend on CONFIG_EXPERT but yeah -- I was surprised to
learn recently even Ubuntu is shipping with CONFIG_EXPERT, so WTF.
Localizing the expert config to wireless might make more sense.

> I still like the idea of exporting more stuff to userspace and letting
> CRDA handle the card-based restrictions, but ISTR you had reasons that
> didn't work for everything.

What do you mean?

  Luis
