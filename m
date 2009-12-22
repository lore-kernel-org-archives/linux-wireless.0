Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47507 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZLVOab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 09:30:31 -0500
Date: Tue, 22 Dec 2009 09:18:58 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Luca Verdesca <magooz@salug.it>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: adding LED support for AR5BXB63 cards
Message-ID: <20091222141858.GA4825@tuxdriver.com>
References: <20091222022135.2102c465@magooz.no-ip.org> <b6c5339f0912211937o525c9117k2e6d877b3c91b858@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6c5339f0912211937o525c9117k2e6d877b3c91b858@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 21, 2009 at 10:37:51PM -0500, Bob Copeland wrote:
> On Mon, Dec 21, 2009 at 8:21 PM, Luca Verdesca <magooz@salug.it> wrote:
> > With following patch, LED should now work with LiteOn AR5BXB63 mini
> > pci-e cards.
> >
> > I hope I made no mistake.
> >
> > Happy hacking!
> > Magooz
> 
> Would you mind re-spinning a patch using the subvendor instead of the
> Atheros device ID?  For all I know, all of the AR5BXB63s are the same,
> but just in case let's stick with subvendor until we know for sure.
> You can get the proper numbers by running lspci -vnn as root, and look
> at the other stanzas for examples.

Please also take note of the following guidelines for posting patches:

	http://www.linux-mips.org/wiki/The_perfect_patch

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
