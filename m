Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:58541 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3LQRFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 12:05:41 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: Circular lock with mac80211_hwsim and DFS
Date: Tue, 17 Dec 2013 18:05:34 +0100
Cc: linux-wireless@vger.kernel.org
References: <87lhzjeqg6.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87lhzjeqg6.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201312171805.34821.sw@simonwunderlich.de> (sfid-20131217_180547_161437_7DF5F20F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi,
> 
> I tried to run a simple DFS test with mac80211_hwsim for the first time
> but got the deadlock below. Is this a regression or has DFS ever worked
> with hwsim?
> 
> Using 31e1798fbf from mac80211-next.

just checked again with mac80211-next for ath9k, and I don't see this lockdep 
problem. Appearently this is a problem in hwsim only ....

Cheers,
   Simon
