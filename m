Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35033 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbXLESNN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 13:13:13 -0500
Subject: Re: [PATCH 0/5] libertas: allow easier command playing
From: David Woodhouse <dwmw2@infradead.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <1196874408.12263.9.camel@localhost.localdomain>
References: <200712051757.52053.hs4233@mail.mn-solutions.de>
	 <1196874408.12263.9.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 18:13:02 +0000
Message-Id: <1196878382.13978.472.camel@pmac.infradead.org> (sfid-20071205_181319_085719_3C152D68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-12-05 at 12:06 -0500, Dan Williams wrote:
> 
> Yeah; need to get this figured out with David; he'll probably start
> yelling loudly if these get acked.  He might be committing/reverting
> locally and just not pushing up to libertas-2.6 until he's ready.
> However, he did promise something by Friday.  I'd almost say push your
> patches to libertas-2.6 and let Woodhouse handle the merge work when
> he pulls from the repo, but he'll probably have a better idea.

Just committing to the git tree as if we were kernel developers works
for me for now.

If we have to abandon git and start playing patchmonkey again later, I
suppose I'll have to deal with that pain then.

-- 
dwmw2

