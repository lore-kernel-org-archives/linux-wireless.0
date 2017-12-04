Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sonic310-28.consmr.mail.ir2.yahoo.com ([77.238.177.49]:33606
        "EHLO sonic310-28.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752779AbdLDWCm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 17:02:42 -0500
Date: Mon, 4 Dec 2017 22:02:39 +0000 (UTC)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: Hin-Tak Leung <htl10@users.sourceforge.net>
To: Gabriele Gristina <gabriele.gristina@gmail.com>
Cc: Herton Ronaldo Krzesinski <herton@canonical.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        <linux-wireless@vger.kernel.org>
Message-ID: <1990723570.2726060.1512424959242@mail.yahoo.com> (sfid-20171204_230246_357410_EA02BFF4)
Subject: Re: [PATCH] rtl8187: add master mode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1990723570.2726060.1512424959242.ref@mail.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------------------------------------
On Mon, 4/12/17, Gabriele Gristina <gabriele.gristina@gmail.com> wrote:
 
> I use these few
> byte from years and hostapd work like a charm.I
> don't understand why you write "completely
> wrong" but you are free to refuse this
> patch.
> Have a nice
> day,Gabriele

I think the issue was to do with hardware support of certain features - power-management (allowing the clients to sleep) and maintaining states across low-power states, and somewhat large number of clients. That it can work to some extent, and even to a very good extent, to serve a small number of clients - at full power, without power managrment - is not a surprise.

My impression that software (i.e. non-hardware) support was to improve to make it possible. Larry and others can comment on the current state.

 
