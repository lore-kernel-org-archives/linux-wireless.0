Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:15704 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754811Ab0EJBPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 21:15:51 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0730604149
	for <linux-wireless@vger.kernel.org>; Mon, 10 May 2010 10:15:50 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>,
	Dan Carpenter <error27@gmail.com>
Subject: Re: [patch 6/9] ath5k: several off by one range checks
Date: Mon, 10 May 2010 10:18:40 +0900
References: <20100508162438.GR27064@bicker> <20100508223319.GA6377@hash.localnet>
In-Reply-To: <20100508223319.GA6377@hash.localnet>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bruno Randolf <br1@einfach.org>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005101018.40169.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 09 May 2010 07:33:19 you wrote:
> On Sat, May 08, 2010 at 06:24:38PM +0200, Dan Carpenter wrote:
> > There are several places that use > ARRAY_SIZE() instead of
> > 
> > >= ARRAY_SIZE().
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> Thanks,
> Acked-by: Bob Copeland <me@bobcopeland.com>

ah, yes. found these too, but haven't sent the patch yet.

Acked-by: Bruno Randolf <br1@einfach.org>
