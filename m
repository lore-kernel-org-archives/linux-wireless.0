Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:64543 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbXIZBwQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 21:52:16 -0400
Received: by py-out-1112.google.com with SMTP id u77so3880932pyb
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 18:52:15 -0700 (PDT)
Message-ID: <40f31dec0709251852v39e9dbffm8873d7041215a516@mail.gmail.com>
Date: Wed, 26 Sep 2007 04:52:15 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 1/3] Net: ath5k, make its own directory
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890709241205j2d020495ufb5f806a4c50ad75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2595810412809010611@pripojeni.net>
	 <1190660419.18521.278.camel@johannes.berg>
	 <46F80A33.2080201@gmail.com>
	 <43e72e890709241205j2d020495ufb5f806a4c50ad75@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/9/24, Luis R. Rodriguez <mcgrof@gmail.com>:
> On 9/24/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> > On 09/24/2007 09:00 PM, Johannes Berg wrote:
> > > On Mon, 2007-09-24 at 14:39 -0400, Jiri Slaby wrote:
> > >> ath5k, make its own directory
> > >
> > >> rename from drivers/net/wireless/ath5k_regdom.c
> > >> rename to drivers/net/wireless/ath5k/ath5k_regdom.c
> > >
> > > imho you should get rid of the ath5k_ prefixes now.
> >
> > It's OK to me, but this is how bcm, prism and zd do it :). If nobody minds, I
> > will get rid of the prefix.
>

O.K. by me too ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
