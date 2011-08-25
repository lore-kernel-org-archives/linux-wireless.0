Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:44633 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab1HYJVo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 05:21:44 -0400
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: Re: [PATCH 0/8] FIXUP: mesh gates
References: <1314235313-4564-1-git-send-email-thomas@cozybit.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 25 Aug 2011 12:21:29 +0300
In-Reply-To: <1314235313-4564-1-git-send-email-thomas@cozybit.com> (Thomas Pedersen's message of "Wed\, 24 Aug 2011 18\:21\:45 -0700")
Message-ID: <87ei09onhi.fsf@purkki.adurom.net> (sfid-20110825_112147_752675_D8FD4CE9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Pedersen <thomas@cozybit.com> writes:

> Since v1 of the mesh gate series was accidentally applied, revert
> the relevant v1s and apply the v2s.

This looks ugly in the git history. IMHO it would be cleaner that you
would do a diff between series v1 and v2 and submit that as a proper
patch.

But John might think otherwise, better to wait for his comment.

-- 
Kalle Valo
