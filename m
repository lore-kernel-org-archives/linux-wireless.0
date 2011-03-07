Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:35286 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635Ab1CGQzB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 11:55:01 -0500
Subject: Re: [PATCH] p54spi: Update kconfig help text
From: Michael Buesch <mb@bu3sch.de>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <201103071742.09073.chunkeey@googlemail.com> (sfid-20110307_174226_236287_00977258)
References: <1299501084.5665.13.camel@marge>
	 <201103071742.09073.chunkeey@googlemail.com>
	 (sfid-20110307_174226_236287_00977258)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 17:54:54 +0100
Message-ID: <1299516894.5665.15.camel@marge>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-07 at 17:42 +0100, Christian Lamparter wrote:
> On Monday 07 March 2011 13:31:24 Michael Buesch wrote:
> > This updates the p54spi Kconfig help text.
> > The driver works well on n8x0, so remove the words "experimental" and "untested".
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> ACK, we'll take your word of it.
> Any news about the power save issue?
> Was it "fixed" by a recent commit or is it no
> longer a problem? 

No I disabled PS as a workaround. Of course, that's
not the real fix I'm hoping for :)

-- 
Greetings, Michael.

