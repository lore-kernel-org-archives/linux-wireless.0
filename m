Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab3FSOLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 10:11:21 -0400
Message-ID: <1371651073.8349.19.camel@jlt4.sipsolutions.net> (sfid-20130619_161126_314861_C2A58806)
Subject: Re: [ath9k-devel] ath9k_htc: station unable to authenticate
From: Johannes Berg <johannes@sipsolutions.net>
To: Ignacy Gawedzki <i@lri.fr>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 19 Jun 2013 16:11:13 +0200
In-Reply-To: <20130619140905.GA14079@zenon.in.qult.net> (sfid-20130619_160921_593309_5728C3A1)
References: <20130619115809.GA26717@zenon.in.qult.net>
	 <51C1ACEC.2020703@rempel-privat.de>
	 <1DC40B07CD6EC041A66726C271A73AE61AA312F5@IRSMSX102.ger.corp.intel.com>
	 <51C1B467.1030509@rempel-privat.de>
	 <20130619140905.GA14079@zenon.in.qult.net>
	 (sfid-20130619_160921_593309_5728C3A1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Btw, I'm a bit confused -- are you using ath9k_htc as per the subject,
or ath9k?

if it's ath9k_htc then I don't really understand why the patch that
*fixed* it for Corey *broke* it for you?

johannes

