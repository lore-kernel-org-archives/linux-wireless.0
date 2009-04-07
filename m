Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46649 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbZDGHtc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 03:49:32 -0400
Received: by mail-fx0-f158.google.com with SMTP id 2so2199256fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2009 00:49:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890904062234m3d572f36t1aa7fefa5f78ae74@mail.gmail.com>
References: <43e72e890904032115m7548f967m5020481c660c8f13@mail.gmail.com>
	 <3ace41890904041944p6cd60084ub2d05a85373459c3@mail.gmail.com>
	 <3ace41890904062120o78018361x409bb3e20b735b75@mail.gmail.com>
	 <43e72e890904062234m3d572f36t1aa7fefa5f78ae74@mail.gmail.com>
Date: Tue, 7 Apr 2009 08:49:30 +0100
Message-ID: <3ace41890904070049tc2ed1baod4399a327505ef09@mail.gmail.com> (sfid-20090407_094936_338475_4708ED41)
Subject: Re: zd1211 3.0.0.56 "vendor driver" - please help port to zd1211rw
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 7, 2009 at 6:34 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:

> Not sure, I wanted to get this out to help those who are interested in
> porting changes over (if any) to zd1211rw. If you find nothing useful
> from it please simply disregard it.

It is vaguely relevant in that (1) there are new and old features
which are not in the rw driver yet - e.g. the AP mode,  and
3.0 introduces newly antenna diversity, (2) to port changes - either
new-hardware related, or bug-fixes/improvements, they need to be
proven to work-better ... e.g. blindly copying could just copy
mistakes/regressions...
