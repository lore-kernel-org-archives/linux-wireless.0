Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailsec108.isp.belgacom.be ([195.238.20.104]:34042 "EHLO
	mailsec108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156AbaI0IW0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2014 04:22:26 -0400
Date: Sat, 27 Sep 2014 10:22:24 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	brcm80211-dev-list@broadcom.com, brudley@broadcom.com
Message-ID: <2023667085.710256.1411806144444.open-xchange@webmail.nmp.skynet.be> (sfid-20140927_102255_742586_6F0D25F6)
In-Reply-To: <20140926174636.GJ22967@tuxdriver.com>
References: <1410809448-15982-1-git-send-email-fabf@skynet.be> <20140926174636.GJ22967@tuxdriver.com>
Subject: Re: [PATCH V2 1/2] brcm80211: use container_of to resolve brcms_phy
 from brcms_phy_pub
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> On 26 September 2014 at 19:46 "John W. Linville" <linville@tuxdriver.com>
> wrote:
>
>
> These two patches don't seem to apply on wireless-next, and I don't
> have time at the moment to fix them up.  Feel free to repost...

Hello John,

        No problem, you already pushed the 2 same patches from the first (too
generic) patchset

        First patchset for drivers/net (see patch 3 and 4)
        http://marc.info/?l=linux-kernel&m=141064073901334&w=2
       
        No updates in V2 anyway:
        ("V2: 2 separate patches for brcm80211")

Wireless-next commits:
a38a9ef1c064
("brcm80211: use container_of to resolve dma_info from dma_pub")

d68e9f5d8549
("brcm80211: use container_of to resolve brcms_phy from brcms_phy_pub")

Regards,
Fabian
