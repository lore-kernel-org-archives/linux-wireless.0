Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:65224 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaCEKas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 05:30:48 -0500
Received: by mail-we0-f178.google.com with SMTP id u56so937641wes.9
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2014 02:30:47 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 5 Mar 2014 11:30:35 +0100
Message-ID: <CAFqH_52V8JPROp_cmJHsVEu4s+s20vbkWgL2xykDoJAAScWmVw@mail.gmail.com> (sfid-20140305_113057_678813_72D45BA1)
Subject: WEP is not working on libertas drivers.
From: Enric Balletbo Serra <eballetbo@gmail.com>
To: david.abd@gmail.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Due a customer requirement I need to configure and ad-hoc network with
wep encryption. This worked fine with a very old kernel (2.6.35) but
now that we need to update the kernel seems this
functionality is totally broken. I found some old messages[1] related
to this without response.

As I'm totally a newbie with this I would like to know if there is a
hard reason why this is still not working or the only reason is
because nobody spent time on this. In that case will be easy implement
this (some indication?)

Any help will be appreciated,

   Enric

[1] http://lists.infradead.org/pipermail/libertas-dev/2011-September/003691.html
