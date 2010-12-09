Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35314 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab0LICms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 21:42:48 -0500
Received: by pva4 with SMTP id 4so406776pva.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 18:42:47 -0800 (PST)
MIME-Version: 1.0
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Thu, 9 Dec 2010 12:36:17 +1000
Message-ID: <AANLkTin6kK69ZGHyDZWFF=yYk8g2PmAuuPc_U-=U=pL=@mail.gmail.com>
Subject: ath5k: IBSS Join Fail
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm currently running 2 Linux nodes. One is running kernel version
2.6.37-rc2, the other -rc5. I'm finding that the rc5 node refuses to
join the IBSS, and simply ignores any probe requests from other
stations. The card is working fine (i.e. I can see other frames coming
up on a monitor-mode interface). The rc2 station sends out probe
requests upon joining the IBSS, but the rc5 station does not.
Reverting the rc5 station to rc2 means that it joins the IBSS
correctly. I'm having a look through the commits to see if any changes
occurred which may affect an IBSS join. I realise I could also bisect,
but it takes me 40mins to rebuild a kernel, so I'm just wondering if
anyone can think of something I can start the search on to fix this?

Cheers,

-- 
Jonathan Guerin
