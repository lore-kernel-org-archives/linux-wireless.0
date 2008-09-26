Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55729 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbYIZXT7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 19:19:59 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 16:19:59 -0700
Date: Fri, 26 Sep 2008 16:19:51 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jiri Benc <jbenc@suse.cz>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [compat-old PATCH 2/2] Allow compilation on 2.6.22
Message-ID: <20080926231951.GF5972@tesla> (sfid-20080927_012003_140310_967D8C5B)
References: <20080926161923.54cb0f66@griffin.suse.cz> <20080926162036.1a181ae1@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20080926162036.1a181ae1@griffin.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 26, 2008 at 07:20:36AM -0700, Jiri Benc wrote:
> This allows compilation of compat-wireless-old on 2.6.22 kernel. I suspect
> some drivers don't work despite they compile, though.
> 
> Signed-off-by: Jiri Benc <jbenc@suse.cz>

Thanks patches pulled and new compat-wireless-old tarball regenerated.

  Luis
