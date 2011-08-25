Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56114 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab1HYNPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 09:15:15 -0400
Date: Thu, 25 Aug 2011 07:45:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 0/8] FIXUP: mesh gates
Message-ID: <20110825114536.GA11153@tuxdriver.com> (sfid-20110825_151519_874141_E381BDC0)
References: <1314235313-4564-1-git-send-email-thomas@cozybit.com>
 <87ei09onhi.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87ei09onhi.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 12:21:29PM +0300, Kalle Valo wrote:
> Thomas Pedersen <thomas@cozybit.com> writes:
> 
> > Since v1 of the mesh gate series was accidentally applied, revert
> > the relevant v1s and apply the v2s.
> 
> This looks ugly in the git history. IMHO it would be cleaner that you
> would do a diff between series v1 and v2 and submit that as a proper
> patch.
> 
> But John might think otherwise, better to wait for his comment.

That is how I would prefer it as well.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
