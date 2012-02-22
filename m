Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47473 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2BVMWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 07:22:52 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.56849.148667.178506@gargle.gargle.HOWL> (sfid-20120222_132306_651307_2BCE9A93)
Date: Wed, 22 Feb 2012 17:52:41 +0530
To: Julian Calaby <julian.calaby@gmail.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 16/26] ath9k_hw: Use CONFIG_ATH9K_BTCOEX_SUPPORT
In-Reply-To: <CAGRGNgUTDAuncGyoXp5Y3pNPvVjPWWppsnH_qj+4HWrJWX-thw@mail.gmail.com>
References: <20292.38178.132196.432415@gargle.gargle.HOWL>
	<CAGRGNgUTDAuncGyoXp5Y3pNPvVjPWWppsnH_qj+4HWrJWX-thw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby wrote:
> > -static inline bool ar9003_mci_is_ready(struct ath_hw *ah)
> > +#else
> > +
> > +#define ar9003_mci_is_ready(...) false
> 
> You missed one =)

Heh, I did fix this, but messed up the git-rebase foo. :)

Sujith
