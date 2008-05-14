Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:34411 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbYENVxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 17:53:02 -0400
Received: by wf-out-1314.google.com with SMTP id 27so90030wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2008 14:53:02 -0700 (PDT)
Subject: Re: [PATCH 5/5] b43: move the register write into
	radio2050_rfover_val
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1210795241.29705.26.camel@johannes.berg>
References: <1210791396.6191.40.camel@brick>
	 <200805142122.21635.mb@bu3sch.de>  <1210793758.6191.43.camel@brick>
	 (sfid-20080514_213609_061251_8D4DC32D)  <1210795241.29705.26.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 14 May 2008 14:53:01 -0700
Message-Id: <1210801981.6191.44.camel@brick> (sfid-20080514_235308_291623_1EB33A77)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-14 at 22:00 +0200, Johannes Berg wrote:
> On Wed, 2008-05-14 at 12:35 -0700, Harvey Harrison wrote:
> > On Wed, 2008-05-14 at 21:22 +0200, Michael Buesch wrote:
> > > On Wednesday 14 May 2008 20:56:36 Harvey Harrison wrote:
> > > > It is always called with the same dev, register value as the
> > > > b43_phy_write that wraps around it, make it return void
> > > > and move the register write into radio2050_rfover_val.
> > > 
> > > NACK to the whole 5 patches.
> > > See the list archives for an explanation.
> > 
> > Any particular reference for nacking 5/5?
> > 
> > While I respectfully disagree with you Re: 1-4 I can't make you take it.
> 
> You could prove that those are correct:
> 
> make the function you're going to use an inline, compile &
> objdump/md5sum, apply the patch conversion, compile & objdump/md5sum &
> compare, make function out of line again

At this point I'll let sleeping dogs lie, it's not worth fighting over.

Harvey

