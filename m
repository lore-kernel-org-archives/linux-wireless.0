Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43920 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbYAMNVK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 08:21:10 -0500
Subject: Re: merge errors on 'everything'
From: David Woodhouse <dwmw2@infradead.org>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Pavel Roskin <proski@gnu.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	bruno randolf <bruno@thinktube.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <87myrf74ix.fsf@nokia.com>
References: <200801091043.02204.bruno@thinktube.com>
	 <20080109015102.GB3048@tuxdriver.com> <1199845968.3697.22.camel@dv>
	 <87myrf74ix.fsf@nokia.com>
Content-Type: text/plain
Date: Sun, 13 Jan 2008 13:10:52 +0000
Message-Id: <1200229852.2647.4.camel@shinybook.infradead.org> (sfid-20080113_132113_317060_D0DAAE58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2008-01-09 at 11:05 +0200, Kalle Valo wrote:
> 
> I do the same and it has worked for me, at least.
> 
> It would be nice if git would somehow do this automatically with
> rebased trees. Or maybe it already supports it and I'm not just aware
> of it?

Why would it? Git isn't designed to handle rebasing nicely -- rebasing
is something that should only ever happen if you screw up and have to
start again. If you rebase you throw away most of what makes git so
useful.

-- 
dwmw2

