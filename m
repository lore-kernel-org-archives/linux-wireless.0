Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f193.google.com ([209.85.214.193]:33268 "EHLO
	mail-ob0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbcF2T6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 15:58:20 -0400
MIME-Version: 1.0
In-Reply-To: <1467230067-3302-1-git-send-email-zajec5@gmail.com>
References: <1466353420-30998-1-git-send-email-zajec5@gmail.com> <1467230067-3302-1-git-send-email-zajec5@gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 29 Jun 2016 21:57:41 +0200
Message-ID: <CACna6rwQ6s0j5k74p=xAtX7Qe=y11Hivbd0hF2=bksZp6rK9gA@mail.gmail.com> (sfid-20160629_215842_326673_96C1CCAB)
Subject: Re: [PATCH 0/2] brcmfmac: support removing AP interfaces with new fw
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<brcm80211-dev-list.pdl@broadcom.com>,
	Network Development <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 June 2016 at 21:54, Rafał Miłecki <zajec5@gmail.com> wrote:
> This is the latest patchset needed to get brcmfmac working reasonably well
> with BCM4366.
>
> Both patches were already sent as V2 RFC (10 days ago), there were no more
> comments since then and this is the same code as in V2 RFC. I was mostly waiting
> for accepting
> brcmfmac: fix lockup when removing P2P interface after event timeout
> before sending these 2 (because of dependency).
>
> Rafał Miłecki (2):
>   brcmfmac: delete interface directly in code that sent fw request
>   brcmfmac: support removing AP interfaces with "interface_remove"
>
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 39 +++++++++++++++++++++-
>  .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    | 10 ++++--
>  .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  3 +-
>  3 files changed, 47 insertions(+), 5 deletions(-)

Oops, I just realized get_maintainer.pl didn't pick any ppl/ML for
this cover letter. Added them now.

-- 
Rafał
