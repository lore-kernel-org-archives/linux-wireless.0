Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44904 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZJGOqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 10:46:46 -0400
Date: Wed, 7 Oct 2009 10:45:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [PATCH] compat-2.6: adding ethtool.h to compat-2.6.31.h
Message-ID: <20091007144502.GA22394@tuxdriver.com>
References: <1254886762-17211-1-git-send-email-HinTak.Leung@gmail.com> <43e72e890910062240w7b4f0895t7f009b99da8fac40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890910062240w7b4f0895t7f009b99da8fac40@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 07, 2009 at 01:40:04AM -0400, Luis R. Rodriguez wrote:
> On Tue, Oct 6, 2009 at 11:39 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> > Between 2.6.30 and 2.6.31, linux/netdevice.h started
> > to include linux/ethtool.h (commit b1b67dd45a6b629eb41553856805aaa1614fbb83,
> > "net: factor out ethtool invocation of vlan/macvlan drivers"),
> > and commit 7508e486965b0af13984bc6d9da62a8d8f0dc5f9,
> > "cfg80211: add firmware and hardware version to wiphy", introduces
> > dependency of ETHTOOL_BUSINFO_LEN from linux/ethtool.h
> > to net/cfg80211.h .
> 
> John's patch titled "cfg80211: fix compile error from missing
> ethtool.h" seems to address this upstream. I'll wait until he applies
> that to the tree.

As Hin-Tak points-out, linux/netdevice.h is alreadying "doing the needful". :-)

I'll just drop my patch and let this get sorted in compat-wireless.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
