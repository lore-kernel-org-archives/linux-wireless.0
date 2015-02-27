Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out4.electric.net ([192.162.216.182]:59196 "EHLO
	smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbbB0KgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 05:36:10 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: 'Joe Perches' <joe@perches.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "David S. Miller" <davem@davemloft.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] wireless: test sscanf return values
Date: Fri, 27 Feb 2015 10:35:04 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CAF0B29@AcuExch.aculab.com> (sfid-20150227_113630_407371_4E2FED11)
References: <1425015791.2690.7.camel@perches.com>
In-Reply-To: <1425015791.2690.7.camel@perches.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joe Perches
> At some point, it'd be good to make sscanf use __must_check
> so make sure the net/ uses of sscanf use the return value.

Isn't it much safer to avoid sscanf() completely and use
a different function for converting numerics?

	David

