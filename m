Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:33209 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883AbZJLU1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 16:27:52 -0400
Received: by bwz6 with SMTP id 6so3411456bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2009 13:27:15 -0700 (PDT)
Date: Mon, 12 Oct 2009 22:23:16 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 2.6.31.[12] ath5k regression
Message-ID: <20091012202316.GA8310@linux-m68k.org>
References: <20090623174616.GA3914@linux-m68k.org> <20090623202541.GA3635@hash.localnet> <20090625083636.GA6323@linux-m68k.org> <20090705123105.GE2132@hash.localnet> <20091009143922.GA7848@linux-m68k.org> <20091010125824.GA18841@hash.localnet> <20091011122616.GA27105@linux-m68k.org> <20091011133010.GA21494@hash.localnet> <20091011220002.GA11603@linux-m68k.org> <20091011222142.M14763@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091011222142.M14763@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 11, 2009 at 06:23:56PM -0400, Bob Copeland wrote:
> On Mon, 12 Oct 2009 00:00:02 +0200, Richard Zidlicky wrote:
> > so the results are same like before. The printk message came once only,
> > I will try to gather more debug info tomorrow.
> 
> Meaning it works the same as with your change (replacing "chan != null"
> with "true") or it works the same as mainline, i.e. it fails?

it works like in mainline and fails.

Richard
