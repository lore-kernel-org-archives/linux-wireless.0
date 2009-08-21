Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:45036 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbZHUM3L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 08:29:11 -0400
Received: by rv-out-0506.google.com with SMTP id f6so245033rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 05:29:13 -0700 (PDT)
Message-ID: <4A8E9315.3000709@lwfinger.net>
Date: Fri, 21 Aug 2009 07:29:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] rtl8187: always set MSR_LINK_ENEDCA flag with RTL8187B
References: <200908202116.17847.herton@mandriva.com.br>	 <4A8DF356.8000501@lwfinger.net> <3ace41890908202054j62fda37ei64262890c6959f95@mail.gmail.com>
In-Reply-To: <3ace41890908202054j62fda37ei64262890c6959f95@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> 
> This seems to be related to a problem I reported a while back - see
> the "compat-wireless won't associate on 2nd load" thread, I wrote on
> May 31. Supposedly I had that problem about a week before that, the
> date on the patch from Johannes is May 14, but I just went back to
> look at the mailing list archive and it looks like there were some
> problem with applying and John did some fix on 20th. So it seems that
> it might be the source of my not being able to load compat-wireless a
> 2nd time; and the description of the problem sounds like it too.
> 
> Sorry I haven't been doing much with compat-wireless lately, so I have
> no firm data whether I have the same problem or not since May - that
> problem only happens if I switch from one compat-wireless to another
> compat-wireless, without rebooting - while I have tried
> compat-wireless in the last two months, I don't think I have followed
> compat-wireless as closely as I should to have two successive
> compat-wireless. I probably should go and have a try now.

This problem was quite strange. My system would fail when the RTL8187B
was inserted when the system booted. Unloading the driver did not
help, but removing/reinstalling the card fixed the problem. As all my
testing had been to install the card after booting, I never saw the
failure.


Larry


