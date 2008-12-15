Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37027 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbYLOUPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 15:15:14 -0500
Date: Mon, 15 Dec 2008 15:10:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: htl10@users.sourceforge.net,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Improve wireless statistics for RTL8187
Message-ID: <20081215201011.GE3519@tuxdriver.com> (sfid-20081215_211518_836159_B7A85C71)
References: <27385.37285.qm@web23104.mail.ird.yahoo.com> <49374C8E.6010500@lwfinger.net> <20081215193549.GD3519@tuxdriver.com> <4946B78F.30006@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4946B78F.30006@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 15, 2008 at 02:01:19PM -0600, Larry Finger wrote:
> John W. Linville wrote:
> > On Wed, Dec 03, 2008 at 09:20:46PM -0600, Larry Finger wrote:

> >> Thanks for the comments. I'll fix up the code and resubmit.
> >>
> >> The dev->max_signal is only needed if the IEEE80211_HW_SIGNAL_UNSPEC flag is
> >> used. Once we switch to IEEE80211_HW_SIGNAL_DBM, then the maximum is known.
> > 
> > I'm dropping this patch from my mailbox.  Is a new version of this
> > still coming?
> 
> It is already in wireless-testing as commit b95e4bc3da1167bba718bc5. It was sent
> to you as "[PATCH V2] rtl8187: Improve wireless statistics for RTL8187" on Dec
> 3. The original should be dropped.

Ah, good...thanks!

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
