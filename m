Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP02.calltower.com ([69.4.184.249]:3444 "EHLO
	L01SLCSMTP02.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799AbZF3Ot7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 10:49:59 -0400
Subject: Re: [PATCH CRDA] Introduce separate HOST and TARGET compilation
 steps.
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1246345190.16256.1.camel@johannes.local>
References: <1246310952.15012.22.camel@jdl-desktop>
	 <1246345190.16256.1.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 09:50:03 -0500
Message-Id: <1246373403.13176.3.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-06-30 at 08:59 +0200, Johannes Berg wrote:
> On Mon, 2009-06-29 at 16:29 -0500, Jon Loeliger wrote:
> > The regdbdump tool is really a host executable that is used
> > during the build process.  It could also be installed and
> > used on the target, but two separate compilations are needed
> > to achieve that goal.
> > 
> > Currently, regdbdump is only built for the target, and thus
> > cross-compilation of the tool is really feasible without
> > this patch (or one like it).
> 
> I don't think John is the correct addressee, Luis maintains this still,

Oh!  Sorry!

> afaik. The only thing I'm not sure about is the separation into host/
> and target/,

Do you have another suggestion?  Another approach would be to
leave the "target" stuff in the top-level directory straight up,
and bury the build of the host "tools" in a sub-directory?

>  but otherwise this seems ok to me.

Thanks.

> johannes

jdl


