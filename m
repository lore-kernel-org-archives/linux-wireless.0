Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2344 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab2JTQUM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Oct 2012 12:20:12 -0400
Message-ID: <5082CF2B.5040805@broadcom.com> (sfid-20121020_182042_809135_F636D6C5)
Date: Sat, 20 Oct 2012 18:19:55 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"brcm80211 development" <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH net-next 04/21] wireless: Convert
 is_<foo>_ether_addr uses to eth_addr_<foo>
References: <cover.1350618006.git.joe@perches.com>
 <bb2235c257e347354d94478bd1be35b89bf90186.1350618009.git.joe@perches.com>
In-Reply-To: <bb2235c257e347354d94478bd1be35b89bf90186.1350618009.git.joe@perches.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/19/2012 05:55 AM, Joe Perches wrote:
> Convert the old ether_addr tests to eth_addr_<foo>.
> Adds api consistency.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>   .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    4 ++--
>   .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +-
>   .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    2 +-
>   drivers/net/wireless/brcm80211/brcmsmac/main.c     |   16 ++++++++--------


