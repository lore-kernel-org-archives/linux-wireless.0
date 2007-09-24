Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:60924 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbXIXTFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 15:05:04 -0400
Received: by py-out-1112.google.com with SMTP id u77so3080923pyb
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2007 12:05:03 -0700 (PDT)
Message-ID: <43e72e890709241205j2d020495ufb5f806a4c50ad75@mail.gmail.com>
Date: Mon, 24 Sep 2007 15:05:02 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/3] Net: ath5k, make its own directory
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <46F80A33.2080201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2595810412809010611@pripojeni.net>
	 <1190660419.18521.278.camel@johannes.berg>
	 <46F80A33.2080201@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/24/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 09/24/2007 09:00 PM, Johannes Berg wrote:
> > On Mon, 2007-09-24 at 14:39 -0400, Jiri Slaby wrote:
> >> ath5k, make its own directory
> >
> >> rename from drivers/net/wireless/ath5k_regdom.c
> >> rename to drivers/net/wireless/ath5k/ath5k_regdom.c
> >
> > imho you should get rid of the ath5k_ prefixes now.
>
> It's OK to me, but this is how bcm, prism and zd do it :). If nobody minds, I
> will get rid of the prefix.

This would be great :-)

  Luis
