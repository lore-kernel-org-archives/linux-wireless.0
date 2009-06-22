Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f224.google.com ([209.85.220.224]:51744 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbZFVUR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 16:17:56 -0400
Received: by fxm24 with SMTP id 24so1007667fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2009 13:17:57 -0700 (PDT)
Date: Mon, 22 Jun 2009 22:15:02 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: kernel crashes, 2.6.30, rt2x00, ath5k, ieee80211_get_*_rate,
	automatic rate control
Message-ID: <20090622201502.GA13052@linux-m68k.org>
References: <20090621134954.GA31505@linux-m68k.org> <20090621180447.GA29469@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20090621180447.GA29469@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 21, 2009 at 02:04:47PM -0400, Bob Copeland wrote:
> On Sun, Jun 21, 2009 at 03:49:54PM +0200, Richard Zidlicky wrote:
> > 
> > The good news - setting a fixed rate appears to prevent all crashes. This is
> > perhaps the reason why wireless developers never see this crashes?
> 
> Sounds like the rate controller.  Does this patch help?
> 
> http://lkml.org/lkml/2009/6/5/269


did not crash for a day which does not prove much yet. I have now added a printk
that would alert me that the bugfix actually did anything and so far waiting to 
see it.

Something is still going very wrong with the automatic rate selection on the rt73usb
device - it is receiving fine with 11-24M but TX rate is not even 1M (50-100Kb/s). 
TX is fine with fixed rates 11-24M.

Richard
