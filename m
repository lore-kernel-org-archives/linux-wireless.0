Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:50363 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab1FHLNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 07:13:49 -0400
Date: Wed, 8 Jun 2011 13:13:40 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: sta_find_ibss (active_ibss=1) in a loop?
Message-ID: <20110608111340.GA25889@zenon.in.qult.net> (sfid-20110608_131353_408919_FDBE0630)
References: <20110603201644.GA7836@zenon.in.qult.net>
 <20110603204939.GA12854@zenon.in.qult.net>
 <20110606110429.GA18775@zenon.in.qult.net>
 <1307370716.3894.10.camel@jlt3.sipsolutions.net>
 <20110606160115.GA31258@zenon.in.qult.net>
 <1307376692.3894.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1307376692.3894.12.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 06, 2011 at 06:11:32PM +0200, thus spake Johannes Berg:
> Oh ok. Well, I think we should put these changes in anyway since I see
> nothing preventing the race now.

After having applied this patch, I haven't seen the problem appear for two
days (and two nights) of testing.  I suppose this sort of confirms the fix.

Thanks again.

Ignacy

-- 
To err is human, to moo bovine.
