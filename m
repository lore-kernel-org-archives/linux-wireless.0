Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:36770 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbZE3U73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 16:59:29 -0400
Received: by fxm12 with SMTP id 12so5033075fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 13:59:30 -0700 (PDT)
Subject: Re: commit #1868cf308a3b3a336fcfe52c5aea4ac12d5e42ac breaks
 wireless on my system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1243716540.13863.32.camel@johannes.local>
References: <1243716437.26585.4.camel@maxim-laptop>
	 <1243716540.13863.32.camel@johannes.local>
Content-Type: text/plain
Date: Sat, 30 May 2009 23:59:25 +0300
Message-Id: <1243717165.5312.3.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-05-30 at 22:49 +0200, Johannes Berg wrote:
> On Sat, 2009-05-30 at 23:47 +0300, Maxim Levitsky wrote:
> > I use nl80211 wpa_suppicant driver.
> > With this commit (have just bisected) I can't connect to same AP twice,
> > and usually only a module reload, or somtimes restart of supplicant
> > help.
> > Actually usually I can't connect again after first successful connection
> > at all.
> 
> Grab Luis's fix.
> 
> johannes

I might sound lazy, but I have searched by mailbox and I haven't see a
mail from Luis R. Rodriguez, after the point we discussed the oops I
have been getting on my system due to BUG_ON in crda code (which still
isn't fixed)


What fix? to what module? kernel drivers, supplicant?


Best regards,
	Maxim Levitsky

