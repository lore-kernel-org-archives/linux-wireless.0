Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12724 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbYJ2T1A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 15:27:00 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 12:27:00 -0700
Date: Wed, 29 Oct 2008 12:26:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Andrey Yurovsky <andrey@cozybit.com>, <'@tesla>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<Jouni.Malinen@atheros.com>
Subject: Re: [PATCH] ath9k: kill ath9k_opmode
Message-ID: <20081029192658.GD6103@tesla> (sfid-20081029_202707_353722_31F6ACDC)
References: <4907cc01.19f8720a.500d.6636@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4907cc01.19f8720a.500d.6636@mx.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 07:35:45PM -0700, Andrey Yurovsky wrote:
> This patch kills ath9k's ath9k_opmode enum by replacing it with nl80211_iftype.
> Compile-tested only.

Thanks, would it be possible for you to rebase on top of sujith's
patches?

  Luis
