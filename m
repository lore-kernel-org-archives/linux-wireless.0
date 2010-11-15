Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62748 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab0KOVz5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 16:55:57 -0500
MIME-Version: 1.0
In-Reply-To: <20101115212520.GD2297@tuxdriver.com>
References: <20101115212520.GD2297@tuxdriver.com>
Date: Mon, 15 Nov 2010 22:55:55 +0100
Message-ID: <AANLkTikZyvZ+vNti_9FTg3JgAC19QFkXDX4nTvaA-YaX@mail.gmail.com>
Subject: Re: pull request: wireless-next-2.6 2010-11-15
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/15 John W. Linville <linville@tuxdriver.com>:
> Here is the traditional first huge pull request intended for the 2.6.38!
>
> Included are the usual batch of updates to various wireless drivers.
> For good measure, Luis also gives us a few wireless regulatory control
> patches as well.
>
> Please let me know if there are problems!

Nothing that should postpone this pull, but could you check for
following patches?
[PATCH] ssb: workarounds: be verbose about hacking SPROM revision,
don't duplicate code
[PATCH] ssb: return -ENOMEM on alloc fail (instead of CRC check's result)
[PATCH] ssb: fail registration for unknown SPROM revision

It looks like you missed them. All 3 were sent on 3.11.2010

-- 
Rafał
