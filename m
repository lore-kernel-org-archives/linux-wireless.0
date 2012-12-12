Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:45137 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049Ab2LLTYo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 14:24:44 -0500
Message-ID: <50C8D9FB.4050107@openwrt.org> (sfid-20121212_202448_295393_B6E5BBFD)
Date: Wed, 12 Dec 2012 20:24:43 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: Daniel Golle <dgolle@allnet.de>,
	"<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
	"<users@rt2x00.serialmonkey.com>" <users@rt2x00.serialmonkey.com>,
	"<sgruszka@redhat.com>" <sgruszka@redhat.com>,
	"<helmut.schaa@googlemail.com>" <helmut.schaa@googlemail.com>,
	"<john@phrozen.org>" <john@phrozen.org>
Subject: Re: [PATCH 2/3] rt2x00: allow disabling bands through platform_data
References: <20121211100404.GA7817@earthship.arig> <5533C657-B24F-4835-9728-E77D65CA9348@gmail.com>
In-Reply-To: <5533C657-B24F-4835-9728-E77D65CA9348@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.12.11. 22:46 keltezéssel, Gertjan van Wingerde írta:
> Hi Daniel,
> 
> On 11 dec. 2012, at 11:04, Daniel Golle <dgolle@allnet.de> wrote:
> 
>>
>> Signed-off-by: Daniel Golle <dgolle@allnet.de>
> 
> Again we need a proper patch description here.
> 
> Also, can you explain why the enabling / disabling of individual bands needs
> to be done via platform data, as opposed to letting user space handle this?

The patch should have been skipped for now. The explanation can be found here:

> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2012-November/005468.html

-Gabor
