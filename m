Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51812 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901Ab3D2KMp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 06:12:45 -0400
Received: from mailout-de.gmx.net ([10.1.76.1]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LuJ7B-1UeHJT2i19-011g0e for
 <linux-wireless@vger.kernel.org>; Mon, 29 Apr 2013 12:12:44 +0200
Message-ID: <517E4796.1010000@rempel-privat.de> (sfid-20130429_121249_210163_8C3AE719)
Date: Mon, 29 Apr 2013 12:12:38 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 1/2] mac80211: Add STBC RX flag to radiotap
References: <1367226260-26755-1-git-send-email-Wojciech.Dubowik@neratec.com> <1367226260-26755-2-git-send-email-Wojciech.Dubowik@neratec.com>
In-Reply-To: <1367226260-26755-2-git-send-email-Wojciech.Dubowik@neratec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 29.04.2013 11:04, schrieb Wojciech Dubowik:
> Add rx flag to radiotap header which tells whether
> Space-Time Block Code was used. At the moment only
> 1 stream STBC is supported.
>
> TODO: Pass information from the driver on how many STBC
> streams have been received.

Hi,
do i understand it correctly, on 2x2 or 2x1 system we will get one 
stream STBC. On 4x4 or 4x2 we will get one or two stream STBC, is it 
correct?
Is it possible that we will get some thing like this any time soon?
-- 
Regards,
Oleksij
