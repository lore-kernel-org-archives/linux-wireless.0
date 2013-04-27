Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61950 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab3D0Sx4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 14:53:56 -0400
Received: from mailout-de.gmx.net ([10.1.76.16]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MJqSQ-1UV3nL10fU-001EM3 for
 <linux-wireless@vger.kernel.org>; Sat, 27 Apr 2013 20:53:55 +0200
Message-ID: <517C1EC1.8060808@rempel-privat.de> (sfid-20130427_205359_157650_A0199073)
Date: Sat, 27 Apr 2013 20:53:53 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath9k: collect statistics about Rx-Dup and Rx-STBC
 packets
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de> <1367087995-8960-1-git-send-email-linux@rempel-privat.de> <CAJ-VmonF9XaVZ6MkP-T3cdfGNjXaroM-rXYcA=TUndicp77UnQ@mail.gmail.com>
In-Reply-To: <CAJ-VmonF9XaVZ6MkP-T3cdfGNjXaroM-rXYcA=TUndicp77UnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 27.04.2013 20:51, schrieb Adrian Chadd:
> Hiya,
>
> Why not just bump rs_flags to be a u16, rather than a u8? then you
> don't need an rs_flags_2.

ok

> (And then go and re-align things inside that struct so you don't waste space.)

hmm.. what do you mean here?
-- 
Regards,
Oleksij
