Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:14123 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756187Ab0LMCSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 21:18:33 -0500
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0827716710
	for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 11:18:31 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jonathan Guerin <jonathan@guerin.id.au>
Subject: Re: ath5k: IBSS Join Fail
Date: Mon, 13 Dec 2010 11:18:30 +0900
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"ath5k-devel" <ath5k-devel@lists.ath5k.org>
References: <AANLkTin6kK69ZGHyDZWFF=yYk8g2PmAuuPc_U-=U=pL=@mail.gmail.com>
In-Reply-To: <AANLkTin6kK69ZGHyDZWFF=yYk8g2PmAuuPc_U-=U=pL=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131118.30405.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu December 9 2010 11:36:17 Jonathan Guerin wrote:
> Hi,
> 
> I'm currently running 2 Linux nodes. One is running kernel version
> 2.6.37-rc2, the other -rc5. I'm finding that the rc5 node refuses to
> join the IBSS, and simply ignores any probe requests from other
> stations. The card is working fine (i.e. I can see other frames coming
> up on a monitor-mode interface). The rc2 station sends out probe
> requests upon joining the IBSS, but the rc5 station does not.
> Reverting the rc5 station to rc2 means that it joins the IBSS
> correctly. I'm having a look through the commits to see if any changes
> occurred which may affect an IBSS join. I realise I could also bisect,
> but it takes me 40mins to rebuild a kernel, so I'm just wondering if
> anyone can think of something I can start the search on to fix this?

True, something broke IBSS merge. Same problem here, I'll try to bisect.

bruno
