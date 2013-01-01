Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:48039 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab3AABaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2012 20:30:13 -0500
Received: by mail-pb0-f48.google.com with SMTP id rq13so7274895pbb.21
        for <linux-wireless@vger.kernel.org>; Mon, 31 Dec 2012 17:30:13 -0800 (PST)
Message-ID: <50E23C19.7050008@lwfinger.net> (sfid-20130101_023020_782396_A415C8D7)
Date: Mon, 31 Dec 2012 19:30:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: "John W. Linville" <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@canonical.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8187 WARN slowpath on suspend with 3.6.11
References: <1356999385.78279.YahooMailClassic@web172301.mail.ir2.yahoo.com>
In-Reply-To: <1356999385.78279.YahooMailClassic@web172301.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/31/2012 06:16 PM, Hin-Tak Leung wrote:
> Hi,
>
> Does either Larry or Herton see the sort of behavior (https://bugzilla.redhat.com/show_bug.cgi?id=891019) on suspend? John, is there anything changed between 3.6.9 and 3.6.11 which would cause this?
>
> Other than a genuine kernel regression, it is possible that it might be fedora specific - I just went from F17 to F18. F18 seems to have an systemd integrated udevd which might behaves differently from the older udevd's... or general funniness with F18 (I noticed another bug https://bugzilla.redhat.com/show_bug.cgi?id=891018 but that might be unrelated).
>
> Anyway, other than whole sale downgrade I think I can try booting 3.6.9 (which suspended cleanly under F17) and see whether it is a F18-specific problem.

Hin-Tak,

My system has never done a suspend/resume with any wireless card, thus I cannot 
check your result. The test with 3.6.9 is a good idea.

Sorry,

Larry


