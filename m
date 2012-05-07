Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41210 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab2EGLaj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 07:30:39 -0400
Message-ID: <1336390235.4325.16.camel@jlt3.sipsolutions.net> (sfid-20120507_133056_481564_90E31153)
Subject: Re: Wireless problem in 3.4-rc5
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Eliad Peller <eliad@wizery.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Date: Mon, 07 May 2012 13:30:35 +0200
In-Reply-To: <4FA19674.90804@lwfinger.net> (sfid-20120502_221835_271123_89998A55)
References: <4FA0405C.8050101@lwfinger.net>
	 <CAB3XZEerHsNUr4p5rTu0msucKUnxXwFxwZVtONrkZ_czmgS+ig@mail.gmail.com>
	 <4FA19674.90804@lwfinger.net> (sfid-20120502_221835_271123_89998A55)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-02 at 15:17 -0500, Larry Finger wrote:
> >>
> >> On my main laptop, this patch causes no problems. On a 3rd box, a BCM4312
> >> (b43) is OK, but an RTL8187L (rtl8187) also fails in the same manner.

Do you get the warning in iface.c:162 as well? It seems this would cause
such problems.

> > i'm not sure this is related to the problem you're facing, but the
> > commit above seems to have some bug in which a packet might get
> > enqueued on invalid queue (0xff) - please try this patch (compile
> > tested only):

Eliad, can you submit that patch with more details?

johannes

