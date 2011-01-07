Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([213.88.146.6]:53888 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754341Ab1AGWNH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 17:13:07 -0500
Message-ID: <20110107221305.6484.qmail@stuge.se>
Date: Fri, 7 Jan 2011 23:13:05 +0100
From: Peter Stuge <peter@stuge.se>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Aleksandar Milivojevic <alex@milivojevic.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
References: <AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com> <AANLkTin8JO4UHUYLufSmPhRw0ZndDdjTpueSOHNQbDiZ@mail.gmail.com> <20110107024432.GC20431@tux> <201101071111.17423.helmut.schaa@googlemail.com> <AANLkTi=cxggOG6xkVQqJ9S+ieg8LD43TSVEYAJW7YFrk@mail.gmail.com> <20110107202224.GI21588@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110107202224.GI21588@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
>         bgscan="simple:30:-45:300"
..
> No Linux distributions today uses this other than ChromeOS, but
> they should all change to use it.

Maybe wpa_supplicant should be changed to use it by default?


//Peter
