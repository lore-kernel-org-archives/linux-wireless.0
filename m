Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:60009 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752647AbcCRRqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 13:46:08 -0400
Message-ID: <1458323163.26915.8.camel@perches.com> (sfid-20160318_184630_107124_DE30E164)
Subject: Re: [PATCH] mac80211: fix order of flag descriptions
From: Joe Perches <joe@perches.com>
To: Luis de Bethencourt <luisbg@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Cc: johannes@sipsolutions.net, davem@davemloft.net,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Fri, 18 Mar 2016 10:46:03 -0700
In-Reply-To: <56EC3DA6.2090105@osg.samsung.com>
References: <1458317369-28185-1-git-send-email-luisbg@osg.samsung.com>
	 <1458318955-32070-1-git-send-email-luisbg@osg.samsung.com>
	 <1458322179.26915.2.camel@perches.com> <56EC3DA6.2090105@osg.samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-03-18 at 17:40 +0000, Luis de Bethencourt wrote:
> On 18/03/16 17:29, Joe Perches wrote:
> > On Fri, 2016-03-18 at 16:35 +0000, Luis de Bethencourt wrote:
> > > Fix order of mac80211_rx_flags description to match the enum.
[]
> > > I want ahead and fixed the order of the descriptions. checkpatch.pl was giving
> > > a warning to my previous patch and I had a hunch it was because the wrong order
> > > breaks the parser. Indeed it does and with this patch below checkpatch.pl does
> > > not complain about this flag descriptions anymore.
> > checkpatch complains?  About what?
> warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'

That's not a checkpatch warning.

cheers, Joe
