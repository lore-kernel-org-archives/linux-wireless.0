Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab0IJQMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 12:12:44 -0400
To: Steve deRosier <steve@cozybit.com>
Subject: Re: [PATCH 5/9] =?UTF-8?Q?libertas=5Ftf=3A=20Moved=20firmware=20loading?=
 =?UTF-8?Q?=20to=20probe=20in=20order=20to=20fetch=20MAC=20address?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Sep 2010 18:12:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<javier@cozybit.com>
In-Reply-To: <AANLkTi=-JhwMmQK5ivX-FpSOV5_Pc3RfoswkFLFdGoFo@mail.gmail.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com> <1283988329-44549-6-git-send-email-steve@cozybit.com> <e23a1b600a18f179fa72d2cadf724d17@localhost> <AANLkTi=r_RdEG-2=gzV7uFNJt1Nynp3qNC-38SQkzhO2@mail.gmail.com> <c9d7238e26d9e276d9c9ef9792f7c7f8@localhost> <AANLkTi=-JhwMmQK5ivX-FpSOV5_Pc3RfoswkFLFdGoFo@mail.gmail.com>
Message-ID: <cd546d0c03f6e92c9d3990d8edda0234@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 9 Sep 2010 20:34:41 -0700, Steve deRosier <steve@cozybit.com>
wrote:
> I think my mac80211 patch "mac80211: Fix dangling pointer in
> ieee80211_xmit" stands 100% alone and fixes a clear bug.  I don't see
> any need to delay that one.

Agree, best resend it outside this series, or if John wants to just
pick it up outside the series.

(Generally, I would ask to send mac80211 patches outside driver
series anyway, because it makes it harder to miss such things)

johannes
