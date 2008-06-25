Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from serv04.lahn.de ([213.239.197.57]:43982 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790AbYFYNoI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 09:44:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by elektra.leun.net (8.13.8/8.13.8/SuSE Linux 0.8) with ESMTP id m5PDhteL007701
	for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 15:43:55 +0200
Date: Wed, 25 Jun 2008 15:43:54 +0200
From: linux-wireless@newton.leun.net
To: linux-wireless@vger.kernel.org
Subject: Re: compat wireless, i3945, tcpdump: Machine freezes
Message-ID: <20080625154354.719cc9b3@localhost> (sfid-20080625_154429_278125_056ED822)
In-Reply-To: <20080618094213.5abd2fbd@localhost>
References: <20080618094213.5abd2fbd@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Wed, 18 Jun 2008 09:42:13 +0200
Michael Leun <linux-wireless@newton.leun.net> wrote:

> I downloaded compat-wireless-2008-06-18, built it, loaded cfg80211.ko,
> mac80211.ko, iwl3945.ko, associated to an ap, started "tcpdump -i
> wlan0 -n" and the machine mostly freezed.
> 
> Mostly means keyboard does not work, no disk-access, no network but
> mouse still works.
[...]

This still happens with compat-wireless-2008-06-25.

-- 
Bye,

Michael Leun

