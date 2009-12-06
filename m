Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53633 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbZLFJ6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 04:58:55 -0500
Received: by fxm5 with SMTP id 5so3911074fxm.28
        for <linux-wireless@vger.kernel.org>; Sun, 06 Dec 2009 01:59:01 -0800 (PST)
Date: Sun, 6 Dec 2009 10:49:07 +0100
From: Richard Zidlicky <rz@linux-m68k.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 2.6.31.[12] ath5k regression
Message-ID: <20091206094907.GA6526@linux-m68k.org>
References: <20090625083636.GA6323@linux-m68k.org> <20090705123105.GE2132@hash.localnet> <20091009143922.GA7848@linux-m68k.org> <20091010125824.GA18841@hash.localnet> <20091011122616.GA27105@linux-m68k.org> <20091011133010.GA21494@hash.localnet> <20091011220002.GA11603@linux-m68k.org> <20091011222142.M14763@bobcopeland.com> <20091012202316.GA8310@linux-m68k.org> <20091012235438.GA24539@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091012235438.GA24539@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

small update, it appears to work very nicely in 2.6.32. No idea what really
caused it, or what fixed it in the end.

Richard

On Mon, Oct 12, 2009 at 07:54:38PM -0400, Bob Copeland wrote:
> On Mon, Oct 12, 2009 at 10:23:16PM +0200, Richard Zidlicky wrote:
> > it works like in mainline and fails.
> 
> Huh, well it should be equivalent to your patch, so I'm stumped
> as to why.
> 
> -- 
> Bob Copeland %% www.bobcopeland.com
> 
