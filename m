Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:59816 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956AbcCWMrl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 08:47:41 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net
Subject: Mapping the mac80211 TX path
Date: Wed, 23 Mar 2016 13:47:33 +0100
Message-ID: <87mvppuzru.fsf@toke.dk> (sfid-20160323_134744_175383_C5CED0F7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone

I've been trying to wrap my head around how the Linux mac80211 stack
actually works. As part of this, I've been drawing flow diagrams of the
code paths. The first one I completed is of the TX path; URL below in
case anyone else finds it useful. And if anyone discovers glaring (or
not) errors, feel free to point them out, of course :)

https://blog.tohojo.dk/2016/03/trying-to-understand-the-linux-mac80211-tx-path.html

-Toke
