Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:56329 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbZE3Wh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 18:37:28 -0400
Received: by bwz22 with SMTP id 22so6792909bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 15:37:29 -0700 (PDT)
Subject: Re: commit #1868cf308a3b3a336fcfe52c5aea4ac12d5e42ac breaks
 wireless on my system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1243717165.5312.3.camel@maxim-laptop>
References: <1243716437.26585.4.camel@maxim-laptop>
	 <1243716540.13863.32.camel@johannes.local>
	 <1243717165.5312.3.camel@maxim-laptop>
Content-Type: text/plain
Date: Sun, 31 May 2009 01:37:24 +0300
Message-Id: <1243723044.25886.2.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-05-30 at 23:59 +0300, Maxim Levitsky wrote:
> On Sat, 2009-05-30 at 22:49 +0200, Johannes Berg wrote:
> > On Sat, 2009-05-30 at 23:47 +0300, Maxim Levitsky wrote:
> > > I use nl80211 wpa_suppicant driver.
> > > With this commit (have just bisected) I can't connect to same AP twice,
> > > and usually only a module reload, or somtimes restart of supplicant
> > > help.
> > > Actually usually I can't connect again after first successful connection
> > > at all.
> > 
> > Grab Luis's fix.
> > 
> > johannes
> 
> I might sound lazy, but I have searched by mailbox and I haven't see a
> mail from Luis R. Rodriguez, after the point we discussed the oops I
> have been getting on my system due to BUG_ON in crda code (which still
> isn't fixed)
> 
> 
> What fix? to what module? kernel drivers, supplicant?
> 

It appears that I don't receive half of mails of linux-wireless
nether they are in spam folder.

I am subscribed to linux-wireless@vger.kernel.org>

For example I see no trace of new intel fullmac driver.

Is gmail that bad?

Best regards,
	Maxim Levitsky

