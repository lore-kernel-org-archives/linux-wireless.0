Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39334 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbYH1VZp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 17:25:45 -0400
Date: Thu, 28 Aug 2008 14:25:42 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Howard Chu <hyc@symas.com>
CC: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] compat-2.6: enable ath9k
Message-ID: <20080828212542.GA9430@tesla> (sfid-20080828_232549_365409_EA848046)
References: <48AF209A.4080805@symas.com> <48B655C8.9020500@symas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <48B655C8.9020500@symas.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 12:37:44AM -0700, Howard Chu wrote:
> This patch enables building the wireless-testing ath9k driver with the
> compat-wireless tarball at
> http://www.orbit-lab.org/kernel/compat-wireless-2.6/2008/08/compat-wireless-2008-08-06.tar.bz2

Thanks. We can fork wireless-testing for old kernels based on this for
compat-wireless. Problem is updates. I suppose each driver maintainer
can supply updates when they want. For that please use compat-masters
list.

I'll create a new tree for this when I get a chance. The list.h changes
should have what we have in the kernel. Although list_splice2() is
functionally equivalent I rather use what the kernel is using the name
will be different though of course.

  Luis
