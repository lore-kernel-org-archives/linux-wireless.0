Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4722 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938085AbXHIOHH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2007 10:07:07 -0400
Date: Thu, 9 Aug 2007 09:53:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	Michael Buesch <mb@bu3sch.de>, Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Make extif driver compilation depend on extif  config
Message-ID: <20070809135326.GB7811@tuxdriver.com>
References: <200708071744.40287.mb@bu3sch.de> <20070808154813.abf55801.akpm@linux-foundation.org> <46BA4E24.3060400@aurel32.net> <20070808164327.45803a64.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070808164327.45803a64.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 08, 2007 at 04:43:27PM -0700, Andrew Morton wrote:

> I'm hopelessly confused by the ssb stuff.  I'm not sure if I have all the
> right stuff, all the latest stuff and I don't understand why some is going
> into git-wireless and some is not.

Once you added ssb patches to -mm, I dropped the ssb stuff from the
mm-master branch of wireless-dev in hopes of avoiding conflicts.

Ugh, it looks like some new stuff has leaked-through -- I'll get rid
of it.

John
-- 
John W. Linville
linville@tuxdriver.com
