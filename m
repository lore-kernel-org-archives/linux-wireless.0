Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab3AVK4j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 05:56:39 -0500
Date: Tue, 22 Jan 2013 11:56:19 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: mcgrof@do-not-panic.com, bhutchings@solarflare.com,
	netdev@vger.kernel.org, edumazet@google.com,
	greearb@candelatech.com, bjorn@mork.no,
	linux-wireless@vger.kernel.org, mirqus@gmail.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH v3] net, wireless: overwrite default_ethtool_ops
Message-ID: <20130122105618.GB2328@redhat.com> (sfid-20130122_115645_001737_A51954CB)
References: <1357934432.2643.4.camel@bwh-desktop.uk.solarflarecom.com>
 <20130111.155936.1799008114956712424.davem@davemloft.net>
 <CAB=NE6XjvupJ5XO0EN0HVwdy61ECWL=Ey0g1gsNm+v8Sen=nsQ@mail.gmail.com>
 <20130121.160404.1007504714461228602.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130121.160404.1007504714461228602.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 21, 2013 at 04:04:04PM -0500, David Miller wrote:
> 
> It's queued up for -stable already as is clearly seen at:
> 
> http://patchwork.ozlabs.org/user/bundle/2566/?state=*

Hmm, this link does not work for me (need user/password).

Anyway, I marked cc -stable in v2 patch, but forgot that in v3.
Committed patch does not include the mark, so I'll post patch
to stable just in case.

Thanks
Stanislaw 
