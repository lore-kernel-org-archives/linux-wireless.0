Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:43670 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbeEIMEp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 08:04:45 -0400
Message-ID: <1525867473.6910.10.camel@sipsolutions.net> (sfid-20180509_140502_759615_442E31F4)
Subject: Re: [PATCH 09/18] net: mac80211.h: fix a bad comment line
From: Johannes Berg <johannes@sipsolutions.net>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 09 May 2018 14:04:33 +0200
In-Reply-To: <20180509090400.0156c0c8@vento.lan>
References: <cover.1525684985.git.mchehab+samsung@kernel.org>
         <cover.1525684985.git.mchehab+samsung@kernel.org>
         <1b14ef4f63547c86c544e112b74acfff2b41f4af.1525684985.git.mchehab+samsung@kernel.org>
         <87fu334p5v.fsf@purkki.adurom.net>
         <1525696706.6049.7.camel@sipsolutions.net>
         <20180509090400.0156c0c8@vento.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-05-09 at 09:04 -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 07 May 2018 14:38:26 +0200
> Johannes Berg <johannes@sipsolutions.net> escreveu:
> 
> > On Mon, 2018-05-07 at 15:37 +0300, Kalle Valo wrote:
> > > Mauro Carvalho Chehab <mchehab+samsung@kernel.org> writes:
> > >   
> > > > Sphinx produces a lot of errors like this:
> > > > 	./include/net/mac80211.h:2083: warning: bad line:  >
> > > > 
> > > > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>  
> > > 
> > > Randy already submitted a similar patch:
> > > 
> > > https://patchwork.kernel.org/patch/10367275/
> > > 
> > > But it seems Johannes has not applied that yet.  
> > 
> > Yeah, I've been super busy preparing for the plugfest.
> > 
> > I'll make a pass over all the patches as soon as I can, hopefully today
> > or tomorrow.
> 
> Thanks. I'll drop it from my patchset, assuming that you'll
> be applying Randy's version or mine via your tree.

Right, I did, just need to send a pull request.

johannes
