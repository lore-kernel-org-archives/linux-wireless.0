Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43832 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbeEIMEI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 08:04:08 -0400
Date: Wed, 9 May 2018 09:04:00 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 09/18] net: mac80211.h: fix a bad comment line
Message-ID: <20180509090400.0156c0c8@vento.lan> (sfid-20180509_140427_008979_CEFB5FEE)
In-Reply-To: <1525696706.6049.7.camel@sipsolutions.net>
References: <cover.1525684985.git.mchehab+samsung@kernel.org>
        <cover.1525684985.git.mchehab+samsung@kernel.org>
        <1b14ef4f63547c86c544e112b74acfff2b41f4af.1525684985.git.mchehab+samsung@kernel.org>
        <87fu334p5v.fsf@purkki.adurom.net>
        <1525696706.6049.7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Mon, 07 May 2018 14:38:26 +0200
Johannes Berg <johannes@sipsolutions.net> escreveu:

> On Mon, 2018-05-07 at 15:37 +0300, Kalle Valo wrote:
> > Mauro Carvalho Chehab <mchehab+samsung@kernel.org> writes:
> >   
> > > Sphinx produces a lot of errors like this:
> > > 	./include/net/mac80211.h:2083: warning: bad line:  >
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>  
> > 
> > Randy already submitted a similar patch:
> > 
> > https://patchwork.kernel.org/patch/10367275/
> > 
> > But it seems Johannes has not applied that yet.  
> 
> Yeah, I've been super busy preparing for the plugfest.
> 
> I'll make a pass over all the patches as soon as I can, hopefully today
> or tomorrow.

Thanks. I'll drop it from my patchset, assuming that you'll
be applying Randy's version or mine via your tree.

Thanks,
Mauro
