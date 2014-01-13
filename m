Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaAMKnr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 05:43:47 -0500
Date: Mon, 13 Jan 2014 11:45:30 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/3 RESUBMIT 2nd time] b43: Fix lockdep splat
Message-ID: <20140113104529.GA1809@redhat.com> (sfid-20140113_114352_045784_FC4351DB)
References: <1389470266-13150-1-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389470266-13150-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 11, 2014 at 01:57:46PM -0600, Larry Finger wrote:
> From: Stanislaw Gruszka <sgruszka@redhat.com>

Just friendly remark that from formal linux patch posting rules point
of view you can not post patch authored by me without my Signed-off-by.
Sorry for not spot this earlier.

Anyway, further patch V2 posted on mailing list is fine. Please don't
change it :-)

On the future, you can use rarely used "Originally-from:" mark for
posting not signed patches from others, like I did on commit 55eaa7c1f
where I sent Linus' code.

Thanks
Stanislaw
