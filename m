Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2672 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563AbXHJWit (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 18:38:49 -0400
Date: Fri, 10 Aug 2007 17:43:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
Message-ID: <20070810214340.GA28812@tuxdriver.com>
References: <20070809224254.11f42716.akpm@linux-foundation.org> <20070810200801.GA16714@hall.aurel32.net> <20070810132019.bc218797.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070810132019.bc218797.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 10, 2007 at 01:20:19PM -0700, Andrew Morton wrote:

> git-wireless now has the usual git catastrophe when merging it against the
> recently-discovered net-2.6.24 tree, so I'll need to do something about
> that first.

I have rebased the wireless-dev tree, and the mm-master branch there
should specifically avoid these merge conflicts.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
