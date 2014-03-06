Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52321 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaCFSpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 13:45:17 -0500
Date: Thu, 6 Mar 2014 13:42:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 00/23] ath9k|ath9k_htc: move dups to common-beacon
Message-ID: <20140306184235.GA7788@tuxdriver.com> (sfid-20140306_194521_978429_F54C7725)
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
 <21266.37896.937680.416439@gargle.gargle.HOWL>
 <5312DD46.3030800@rempel-privat.de>
 <21266.58035.719712.344551@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <21266.58035.719712.344551@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 02, 2014 at 01:20:11PM +0530, Sujith Manoharan wrote:
> Oleksij Rempel wrote:
> > I was thinking about it too, but suddenly i don't have enough time and
> > experience to do it. Beside, there is no need to write usb layer. It is
> > clean and separate from other part of the driver. But the HTC/WMI
> > interface is not completely separate.
> 
> Sure. It is just another option to consider.
> 
> > Now about bigger picture. Right now i work only on ath9k<>ath9k_htc
> > dups. But there are lots of dup code in ath9k itself. For example
> > *_phy.c, *_initvals.h. Here are some examples:
> 
> We already have duplicate detection for initvals. It is part of
> the initvals tool in qca-swiss-army-knife.

So, where does this leave us?  Should this series be merged?  Or not?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
