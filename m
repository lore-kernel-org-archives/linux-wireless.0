Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45052 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaEVSAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 14:00:13 -0400
Date: Thu, 22 May 2014 13:45:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: fixup "ath9k_htc: fix build with disabled debug"
Message-ID: <20140522174519.GA12779@tuxdriver.com> (sfid-20140522_200020_604874_1AE758E6)
References: <1400614697-25844-1-git-send-email-linville@tuxdriver.com>
 <537BBA5C.6000705@rempel-privat.de>
 <537C36EC.10503@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537C36EC.10503@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2014 at 07:17:32AM +0200, Oleksij Rempel wrote:
> Am 20.05.2014 22:26, schrieb Oleksij Rempel:
> > Am 20.05.2014 21:38, schrieb John W. Linville:
> >> Apparently Oleksij's compile testing was no better than mine initially
> >> was... :-(
> > 
> > Face palm. There is really no excuse for me :(
> 
> Hi John,
> 
> i won't to create my testsystem to make at least good compile tests. Can
> you share your experience? Do you use some thing like
> http://jenkins-ci.org/ or have your own scripts? If scripts, can you
> please share them?

I'm not sure I have much to offer.  I usually build with an
'allyesconfig' in the wireless and wireless-next trees, and with a
Fedora-like config in wireless-testing.  The combination seems to
catch some things, but I'm sure there are other bad combinations that
slip through...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
