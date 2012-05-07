Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:34719 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179Ab2EGOTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 10:19:31 -0400
Message-ID: <4FA7D932.1020803@01019freenet.de> (sfid-20120507_161935_104205_B500628A)
Date: Mon, 07 May 2012 16:16:18 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: hostap@lists.shmoo.com,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] [rt2800pci (AP) - ath9k] 802.11w: broken aggregation
 handling?
References: <4FA75983.9040003@01019freenet.de> <201205070702.q4772uem002960@mail.maya.org> <20120507135917.GB19222@w1.fi>
In-Reply-To: <20120507135917.GB19222@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jouni,

thanks for your response!

Jouni Malinen wrote:
> On Mon, May 07, 2012 at 09:02:58AM +0200, Andreas Hartmann wrote:
>> - Why is the authentication started here at all, regardless of an error?
> 
> I don't think that hostapd would verify driver capabilities for 802.11w
> at the moment, so it does not know that it should have rejected the
> configuration here.. Same for wpa_supplicant and station mode, I'd
> guess.

Wouldn't it be better, if it would stop processing completely? I was
surprised to have a half working connection :-).

[...]

Kind regards,
Andreas Hartmann
