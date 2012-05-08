Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41312 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab2EHQae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 12:30:34 -0400
Received: by gglu4 with SMTP id u4so972834ggl.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 09:30:34 -0700 (PDT)
Date: Tue, 8 May 2012 12:30:18 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Vadim <Vadims.Kurmis@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Adding custom channels to ath5k for researching purposes
Message-ID: <20120508163018.GE25400@localhost> (sfid-20120508_183038_201696_19A85632)
References: <loom.20101104T140201-178@post.gmane.org>
 <AANLkTinMSH2Vr=iUTD0Pc_OdaM_LFETDEjsOJn+2ZzVD@mail.gmail.com>
 <CAB=NE6X=iD7Hh7-wFx8-ZudNWUKKJw1Mg5MC_G3z4knu7bNTqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6X=iD7Hh7-wFx8-ZudNWUKKJw1Mg5MC_G3z4knu7bNTqg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 08, 2012 at 07:50:06AM -0700, Luis R. Rodriguez wrote:
> I'm thinking it may make sense to add CONFIG_WIRELESS_EXPERT where we
> can stuff some of this stuff under. It may be useful for other
> regulatory testing / certification stuff.

No objection here, so long as this kind of config opt wouldn't become
a dumping ground (cf. CONFIG_EMBEDDED).  "EXPERT" could mean different
things to different people.

I still like the idea of exporting more stuff to userspace and letting
CRDA handle the card-based restrictions, but ISTR you had reasons that
didn't work for everything.

-- 
Bob Copeland %% www.bobcopeland.com
