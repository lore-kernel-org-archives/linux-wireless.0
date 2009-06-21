Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:27539 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZFUUlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2009 16:41:07 -0400
Received: by fg-out-1718.google.com with SMTP id 16so912082fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jun 2009 13:41:08 -0700 (PDT)
Date: Sun, 21 Jun 2009 22:38:39 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: kernel crashes, 2.6.30, rt2x00, ath5k, ieee80211_get_*_rate,
	automatic rate control
Message-ID: <20090621203839.GA6887@linux-m68k.org>
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

will try ASAP, should have results on Monday

Richard
