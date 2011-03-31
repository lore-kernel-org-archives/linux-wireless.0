Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:37517 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758463Ab1CaPqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 11:46:46 -0400
Date: Thu, 31 Mar 2011 18:46:38 +0300
From: Jouni Malinen <j@w1.fi>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ec15e68ba6a regresion?
Message-ID: <20110331154638.GA28649@jm.kir.nu>
References: <20110331154232.GA7370@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110331154232.GA7370@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 31, 2011 at 05:42:41PM +0200, Stanislaw Gruszka wrote:
> Seems commit:
> 
> commit ec15e68ba6a505631016f230899bafbb7b8cd0d6
> Author: Jouni Malinen <jouni.malinen@atheros.com>
> Date:   Wed Mar 23 15:29:52 2011 +0200
> 
>     cfg80211: Add nl80211 event for deletion of a station entry
> 
> is causing problems on my system. Sometimes when I disconnect
> from wireless network, I can not connect again. Without commit
> I can not reproduce the problem.

That sounds strange.. That commit is supposed to just add a new nl80211
event that existing user space tools would ignore (and new
wpa_supplicant snapshot would only use in the case of IBSS). Would it be
possible to get a wpa_supplicant debug log showing this problem?

-- 
Jouni Malinen                                            PGP id EFC895FA
