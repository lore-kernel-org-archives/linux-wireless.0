Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm17-vm0.bullet.mail.ird.yahoo.com ([77.238.189.214]:43335 "HELO
	nm17-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751684Ab2FSO6l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:58:41 -0400
Message-ID: <1340117919.75084.YahooMailClassic@web29404.mail.ird.yahoo.com> (sfid-20120619_165850_483553_0A15757D)
Date: Tue, 19 Jun 2012 15:58:39 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: rtl8187 on compat-wireless Re: regression?
To: herton@canonical.com, Larry.Finger@lwfinger.net,
	Shane Klinedinst <services@beyondcr.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two things: (1) you must cc one of the relevant mailing lists, or this is treated as private consultancy and you get charged correspondingly, (2) use a better/specific subject on e-mails than a non-describe one like "regression". I (and others) get a lot of e-mails, some from "for reference" mailing list subscriptions which just get filed and not read for months or years.

These are done for you this once. - I don't know this "PaulFertser" is, but you better explain those rules to him, for future reference.

The 3rd thing is, as a rule, kernel-related e-mails should be always plain text, no html, no styling and no what not (Linus' rule, not mine). And the final and most important one: why is your kernel "Tainted"? In general, we don't look at bug reports for 'Tainted' kernels.

The 6th thing is, why are you using a compat-wireless which is over a month old? compat-wireless is what it is, bleeding edge snpashot code, you may need to try a different snapshot.
[    6.481568] Compat-wireless backport release: compat-wireless-2012-05-04
[    6.481570] Backport based on linux-next.git next-20120510

--- On Tue, 19/6/12, Shane Klinedinst <services@beyondcr.com> wrote:

From: Shane Klinedinst <services@beyondcr.com>
Subject: regression?
To: herton@canonical.com, htl10@users.sourceforge.net, Larry.Finger@lwfinger.net
Date: Tuesday, 19 June, 2012, 12:12

Hello, I cannot get my wireless interface to work with compat-wireless nomatter what I do here is my dmesg file any and all suggestions will be greatly appreciated http://pastebin.com/yq8FZd5y PaulFertser said it looks like a regression and I should mail the driver maintainer. I am not good at this type of thing but if you need any more information just tell me what to do. Thanks.

Best wishes,Shane Klinedinst

