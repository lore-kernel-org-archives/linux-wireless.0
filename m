Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49415 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab1FAIsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 04:48:31 -0400
Subject: Re: [PATCH v7] mac80211_hwsim driver support userspace frame tx/rx
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier =?ISO-8859-1?Q?L=F3pez?= <jlopex@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com, j@w1.fi,
	javier@cozybit.com
In-Reply-To: <BANLkTinE0axwc_X9Gt=qdrjufopvPNADng@mail.gmail.com> (sfid-20110601_095219_358383_ED40DB77)
References: <BANLkTi=_snQBSFH-d344bjk8-aSeC9Jh5w@mail.gmail.com>
	 <1306879610-21242-1-git-send-email-jlopex@gmail.com>
	 <1306901814.3867.1.camel@jlt3.sipsolutions.net>
	 <BANLkTinE0axwc_X9Gt=qdrjufopvPNADng@mail.gmail.com>
	 (sfid-20110601_095219_358383_ED40DB77)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 10:48:26 +0200
Message-ID: <1306918106.3867.7.camel@jlt3.sipsolutions.net> (sfid-20110601_104839_637026_AD1E11E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-01 at 09:51 +0200, Javier López wrote:

> This file includes the necessary enums and data structures. If I
> follow the nl80211 structure, should I move the file
> "mac80211_hwsim.h" to "include/linux" and make it available to
> userspace?

I don't think that's necessary, but I don't see why you include
net/mac80211.h since the file doesn't need anything from it.

johannes

