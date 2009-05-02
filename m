Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41752 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403AbZEBVS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 17:18:26 -0400
Subject: Re: [PATCH] add version.h to .gitignore
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241298417.13562.26.camel@johannes.local>
References: <1241294826-27585-1-git-send-email-marcel@holtmann.org>
	 <1241298417.13562.26.camel@johannes.local>
Content-Type: text/plain
Date: Sat, 02 May 2009 14:18:16 -0700
Message-Id: <1241299096.4412.20.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > ---
> >  .gitignore |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/.gitignore b/.gitignore
> > index 16bb88b..edc6864 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -3,5 +3,6 @@ iw
> >  *.o
> >  .config
> >  version.c
> > +version.h
> 
> Nah, just rm version.h, it won't be rebuilt :)

my bad. That file was dangling around and I never bothered to check if
it still gets created :(

Regards

Marcel


