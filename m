Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3205 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356Ab2IJUYH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 16:24:07 -0400
Message-ID: <504DE996.4020709@broadcom.com> (sfid-20120910_222411_760064_03A12293)
Date: Mon, 10 Sep 2012 15:22:30 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Arend van Spriel" <arend@broadcom.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: Re: [PATCH 0/2] brcmsmac: fix for regulatory rules and flush
 callback
References: <1346838562-4818-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1346838562-4818-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2012 11:49 AM, Arend van Spriel wrote:
> Two fixes intended for the wireless tree. The issue with the .flush() has
> been giving me a lot of email from RedHat's bugzilla server. Hope this
> patch will silence that ;-)

Hi John,

I should remove that smile above, but are you planning to take these for 
v3.6. At least the first patch is a clear bug fix that I would like
to have applied.

Gr. AvS

>
> Arend van Spriel (2):
>    brcmsmac: fix mismatch in number of custom regulatory rules
>    brcmsmac: rework of mac80211 .flush() callback operation
>
>   drivers/net/wireless/brcm80211/brcmsmac/channel.c  |    2 +-
>   .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   41 +++++++++++++-------
>   .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    3 +-
>   drivers/net/wireless/brcm80211/brcmsmac/main.c     |   21 +++-------
>   drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    4 +-
>   5 files changed, 38 insertions(+), 33 deletions(-)
>


