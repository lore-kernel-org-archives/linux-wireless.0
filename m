Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:53668
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936314AbXHIOJZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2007 10:09:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ssb: Make extif driver compilation depend on extif config
Date: Thu, 9 Aug 2007 16:08:43 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
References: <200708071744.40287.mb@bu3sch.de> <20070808164327.45803a64.akpm@linux-foundation.org> <20070809135326.GB7811@tuxdriver.com>
In-Reply-To: <20070809135326.GB7811@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708091608.43994.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 August 2007 15:53:26 John W. Linville wrote:
> On Wed, Aug 08, 2007 at 04:43:27PM -0700, Andrew Morton wrote:
> 
> > I'm hopelessly confused by the ssb stuff.  I'm not sure if I have all the
> > right stuff, all the latest stuff and I don't understand why some is going
> > into git-wireless and some is not.
> 
> Once you added ssb patches to -mm, I dropped the ssb stuff from the
> mm-master branch of wireless-dev in hopes of avoiding conflicts.
> 
> Ugh, it looks like some new stuff has leaked-through -- I'll get rid
> of it.

I think we decided that it was not a good idea to maintain ssb in
the -mm tree, so I think we'll have to maintain it in a seperate
branch of wireless-dev. Any idea?

-- 
Greetings Michael.
