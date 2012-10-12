Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48068 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759663Ab2JLPNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 11:13:20 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1917382eek.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2012 08:13:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPwP7cSMsdU0LtuMBbnFLoZRWkoPfyT1ahaEfKohf5zJ-Xr6uA@mail.gmail.com>
References: <CAPwP7cSMsdU0LtuMBbnFLoZRWkoPfyT1ahaEfKohf5zJ-Xr6uA@mail.gmail.com>
From: Danilo Tardioli <dannnilo@hotmail.com>
Date: Fri, 12 Oct 2012 17:12:58 +0200
Message-ID: <CAPwP7cQJuJwzQjeYqtjrz-TPfyE+Dd8XFsb_PvsMCmCg=a-8Fw@mail.gmail.com> (sfid-20121012_171326_084198_B286C3AC)
Subject: Broadcast Rate
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everybody,
this is my first post here.
I've been looking for a solution to my problem through the mailing
list but I couldn't find it.
I'm  developing a protocol that pretends to use 802.11 wireless card
as simply transmitter and receiver devices.
I mean my idea is to simply that to send  and receive frames. Up to
the moment I'm able to transmit and receive frames talking directly to
the mac80211 module using a simple patch that I've written.
My problem is that such a protocol uses broadcast frames that are, by
default, sent at the lowest rate (1/2 Mbit/s for 802.11b/g and 6Mbit/s
for 802.11a).
I've been looking in the code how to force the mac80211 or even the
specific driver (e.g. b43 or iwlagn) to send broadcast frames at
higher rates but I feel a little lost since I don't have the global
vision on how all the wireless stuffs work together.

I've read in

http://article.gmane.org/gmane.linux.kernel.wireless.general/46121/match=broadcast+rate

that maybe the solution could be to specify 'only a single rate in the
basic rate set' but, where's is specified the basic rate set.

If someone could give me an hint on how to get documentation about
mac80211 and its interaction with lower level drivers of directly on
my problem, it would be highly appreciated.

Thanks in advance.
Regards,
 Danilo
