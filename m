Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4677 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933854AbXHIOgm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2007 10:36:42 -0400
Date: Thu, 9 Aug 2007 10:01:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Make extif driver compilation depend on extif  config
Message-ID: <20070809140157.GC7811@tuxdriver.com>
References: <200708071744.40287.mb@bu3sch.de> <46BA4E24.3060400@aurel32.net> <20070808164327.45803a64.akpm@linux-foundation.org> <200708090202.20267.mb@bu3sch.de> <20070808171330.b374ec12.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070808171330.b374ec12.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 08, 2007 at 05:13:30PM -0700, Andrew Morton wrote:

> Yeah, after dropping all the ssb stuff, my build is now busted because
> the bit of git-wireless which I have wants SSB bits for BCM43XX.
> 
> argh.  I'll try disabling b44 so I can get a release out the door.
> Please, just give me some internally-consistent tree(s) to pull??

I'm sorry, I seem to have made a hash of this.  I was trying to get
out of the way of Michael's ssb stuff going to -mm, but instead I
seem to have confused things.

Based on the other messages in this thread, I'm going to recreate
the mm-master branch to include the ssb stuff so Andrew can get on
with his life.

Michael, as you mentioned I'm (still) planning a wireless-dev rebase.
If you could send me a clean "add ssb to mainline" patchset to seed
a new ssb branch, that would be great.

I apologize for the confusion!

John
-- 
John W. Linville
linville@tuxdriver.com
