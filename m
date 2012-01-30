Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm23-vm2.bullet.mail.ird.yahoo.com ([212.82.109.231]:21544 "HELO
	nm23-vm2.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751097Ab2A3Lvg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:51:36 -0500
Message-ID: <1327924292.6683.YahooMailClassic@web29506.mail.ird.yahoo.com> (sfid-20120130_125139_656589_7A6F602A)
Date: Mon, 30 Jan 2012 11:51:32 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: rtl8187 behavior change/breakage with 3.2.1-3.fc16.x86_64<->3.2.2-1.fc16.x86_64
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@canonical.com>
In-Reply-To: <4F25BD09.3060607@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Sun, 29/1/12, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> > This may be a fedora-specific problem - I noticed that
> just after booting into the new fedora kernel
> (3.2.2-1.fc16.x86_64), I am getting a strange message from
> the kernel:
> >
> > rtl8187: Invalid hwaddr! Using randomly generated MAC
> address


> I just checked, and rtl8187 works fine with my RTL8187L
> using 3.3-rc1 from 
> wireless-testing. I don't know where the problem occurs.

Thanks for looking. It is mostly likely a fedora-specific problem then. Unless John has any idea, I'll eventually unpacking the fedora kernel source if the problem persists for another kernel.

Cheers,
Hin-Tak

P.S. Herton's e-mail seems to have changed. 
