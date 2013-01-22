Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:55704 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3AVTG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 14:06:26 -0500
Date: Tue, 22 Jan 2013 14:06:23 -0500 (EST)
Message-Id: <20130122.140623.481143614571024168.davem@davemloft.net> (sfid-20130122_200633_587851_03980BB9)
To: sgruszka@redhat.com
Cc: mcgrof@do-not-panic.com, bhutchings@solarflare.com,
	netdev@vger.kernel.org, edumazet@google.com,
	greearb@candelatech.com, bjorn@mork.no,
	linux-wireless@vger.kernel.org, mirqus@gmail.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH v3] net, wireless: overwrite default_ethtool_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130122105618.GB2328@redhat.com>
References: <CAB=NE6XjvupJ5XO0EN0HVwdy61ECWL=Ey0g1gsNm+v8Sen=nsQ@mail.gmail.com>
	<20130121.160404.1007504714461228602.davem@davemloft.net>
	<20130122105618.GB2328@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Tue, 22 Jan 2013 11:56:19 +0100

> On Mon, Jan 21, 2013 at 04:04:04PM -0500, David Miller wrote:
>> 
>> It's queued up for -stable already as is clearly seen at:
>> 
>> http://patchwork.ozlabs.org/user/bundle/2566/?state=*
> 
> Hmm, this link does not work for me (need user/password).

You just need to make a patchwork login, it's visible to any
registered user.

> Anyway, I marked cc -stable in v2 patch, but forgot that in v3.
> Committed patch does not include the mark, so I'll post patch
> to stable just in case.

Do NOT DO THIS, I do the submissions myself, by hand.
