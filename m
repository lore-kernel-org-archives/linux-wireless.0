Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:64933 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXJICh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 22:37:57 -0400
Received: by py-out-1112.google.com with SMTP id u77so2765505pyb
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2007 19:37:56 -0700 (PDT)
Message-ID: <40f31dec0710081937p43048223o4d6826f8de4b9520@mail.gmail.com> (sfid-20071009_033810_639841_CA5F7114)
Date: Tue, 9 Oct 2007 05:37:55 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 6/6] ath5k: Do not let the driver through for not yet supported radios
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <20071008204858.GC7633@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo>
	 <20071006011837.GB25022@pogo> <20071006011923.GC25022@pogo>
	 <20071006011949.GD25022@pogo> <20071006012017.GE25022@pogo>
	 <20071006012057.GF25022@pogo>
	 <40f31dec0710070313k6514882bkf5676d06ced25c53@mail.gmail.com>
	 <20071008204858.GC7633@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/10/8, Luis R. Rodriguez <mcgrof@gmail.com>:
> On Sun, Oct 07, 2007 at 03:13:28AM -0700, Nick Kossifidis wrote:
> > NACK i have a better fix wich uses chip srev, i had commited it on
> > ath5k branch on madwifi svn...
> >
> > what's going on ? noone read my chagnes n ath5k branch on madwifi svn
> > ? i did this change some time ago (over a month) and it seems you
> > didn't even saw it...
> >
> > http://madwifi.org/changeset/2703
> > http://madwifi.org/changeset/2704
> >
> > what happened to my changes ? you told me you would commit them here...
>
> I had said I would but Jiri sent some patches based on your work which
> I thought included your latest changes. Instead of bitching about
> things you should start sending patches, that would be more helpful.
>
> Anyway I actually like that approach more, thanks. John -- I'll send in a new
> patch series.
>
>         Luis
>

You are right but i was on a trip and i couldn't work on it, before i
left wireless-dev wouldn't boot for me so i couldn't test any patch.
I'll try again wireless-dev and I'll send a patch series here.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
