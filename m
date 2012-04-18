Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2DRCAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 22:00:07 -0400
Message-ID: <1334714368.3725.30.camel@jlt3.sipsolutions.net> (sfid-20120418_040010_453095_7E01962F)
Subject: Re: [PATCH 0/4] Mesh sync fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>,
	Pavel Zubarev <pavel.zubarev@gmail.com>,
	devel@lists.open80211s.org, ashok@cozybit.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 17 Apr 2012 18:59:28 -0700
In-Reply-To: <1334266343-3970-1-git-send-email-javier@cozybit.com> (sfid-20120412_233308_365486_4421F410)
References: <1334266343-3970-1-git-send-email-javier@cozybit.com>
	 (sfid-20120412_233308_365486_4421F410)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-12 at 14:32 -0700, Javier Cardona wrote:
> We noticed these while testing mesh synchronization.

I think these patches were merged, but there seems to have been some
confusion about what changes belong into what patch -- please try to be
more careful about that.

Also -- no users for TOFFSET_SET_MARGIN?

johannes

