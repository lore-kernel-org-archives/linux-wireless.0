Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:60311 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751506Ab3CRRXO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 13:23:14 -0400
Message-ID: <1363627392.2074.21.camel@joe-AO722> (sfid-20130318_182321_849242_42B5491A)
Subject: Re: [PATCH] libertas: drop maintainership
From: Joe Perches <joe@perches.com>
To: Dan Williams <dcbw@redhat.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Daniel Drake <dsd@laptop.org>, Bing Zhao <bzhao@marvell.com>
Date: Mon, 18 Mar 2013 10:23:12 -0700
In-Reply-To: <1363625321.1597.28.camel@dcbw.foobar.com>
References: <1363625321.1597.28.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-18 at 11:48 -0500, Dan Williams wrote:
> Would be better maintained by somebody who actualy has time for it.
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> -MARVELL LIBERTAS WIRELESS DRIVER
> -M:	Dan Williams <dcbw@redhat.com>
> -L:	libertas-dev@lists.infradead.org
> -S:	Maintained
> -F:	drivers/net/wireless/libertas/

I think it better to mark it as Orphan
and maybe leave the list.

Maybe:

MARVELL LIBERTAS WIRELESS DRIVER
L:	libertas-dev@lists.infradead.org
S:	Orphan
F:	drivers/net/wireless/libertas/

or

MARVELL LIBERTAS WIRELESS DRIVER
S:	Orphan
F:	drivers/net/wireless/libertas/


