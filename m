Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:36891 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbZKEFQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 00:16:11 -0500
Received: by ywh40 with SMTP id 40so6999754ywh.33
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 21:16:17 -0800 (PST)
Message-ID: <4AF25F9E.2050808@lwfinger.net>
Date: Wed, 04 Nov 2009 23:16:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Richard Farina <sidhayn@gmail.com>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	"John W. Linville" <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix kernel oops when device is removed when
 LEDS enabled (Bugzilla #14539)
References: <4af11879./IumKJ+RAbw7Zkq6%Larry.Finger@lwfinger.net> <200911041630.20122.chunkeey@googlemail.com> <20091104164938.GG12965@tuxdriver.com> <200911042214.54230.herton@mandriva.com.br> <4AF239A6.5050406@lwfinger.net> <4AF25AA6.60606@gmail.com>
In-Reply-To: <4AF25AA6.60606@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2009 10:55 PM, Richard Farina wrote:
> Using kernel 2.6.29 and compat-wireless-stable 2.6.31* I am able to make
> it flake.  I may be the only one lucky enough to make this explode with
> a high degree of accuracy but I can't see why we wouldn't fix what we
> know is a bug waiting to happen.  My vote is to add this patch to
> 2.6.31.x as well.

With compat-wireless-stable 2.6.31, you essentially have the wireless
drivers of 2.6.32, which does have the problem. I could not make the
problem happen with vanilla 2.6.31, which is why I do not think we
need to send the fix to 2.6.31.Y. Of course, your system is much more
sensitive than mine. If you get the kernel panic with 2.6.31, then we
will need to reconsider. As openSUSE 11.2 will be out in a little over
a week using the 2.6.31 kernel, the problem may show up there.

Larry
