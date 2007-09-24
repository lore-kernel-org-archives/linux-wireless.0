Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50640
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbXIXT6v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 15:58:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: zd1211 config operation problem
Date: Mon, 24 Sep 2007 21:58:37 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <200709231648.17107.mb@bu3sch.de> <1190654401.18521.272.camel@johannes.berg> <1190654481.18521.274.camel@johannes.berg>
In-Reply-To: <1190654481.18521.274.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709242158.37848.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 24 September 2007, Johannes Berg wrote:
> On Mon, 2007-09-24 at 19:20 +0200, Johannes Berg wrote:
> > On Mon, 2007-09-24 at 18:41 +0200, Michael Buesch wrote:
> > 
> > > -	if (local->ops->config)
> > > +	if (local->open_count)
> > >  		ret = local->ops->config(local_to_hw(local), &local->hw.conf);
> > 
> > Isn't this racy?
> 
> Also, shouldn't we then call ->config when the first interface is
> brought up or something?

I don't know. You are the one who knows the code. ;)
I'm just pointing at problems that I'm not able to fix,
because I don't know the code.

