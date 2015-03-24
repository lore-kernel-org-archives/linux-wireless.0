Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbbCXSZT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 14:25:19 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: rtl8723au: Remove uses of MAC_FMT and MAC_ARG
References: <1427220609.5642.39.camel@perches.com>
Date: Tue, 24 Mar 2015 14:25:10 -0400
In-Reply-To: <1427220609.5642.39.camel@perches.com> (Joe Perches's message of
	"Tue, 24 Mar 2015 11:10:09 -0700")
Message-ID: <wrfj8ueml0c9.fsf@redhat.com> (sfid-20150324_192537_539169_939938DA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:
> Use the standard vsprintf kernel extension to format
> mac addresses.
>
> This reduces object code size a bit.
>
> Miscellanea:
>
> o Coalesce formats
> o Realign arguments
> o Remove the now unused MAC_FMT and MAC_ARG #defines
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_ap.c           | 41 ++++++-------
>  drivers/staging/rtl8723au/core/rtw_mlme.c         | 26 ++++----
>  drivers/staging/rtl8723au/core/rtw_mlme_ext.c     | 72 +++++++++++------------
>  drivers/staging/rtl8723au/core/rtw_recv.c         | 42 +++++--------
>  drivers/staging/rtl8723au/core/rtw_wlan_util.c    |  6 +-
>  drivers/staging/rtl8723au/core/rtw_xmit.c         |  8 +--
>  drivers/staging/rtl8723au/include/ieee80211.h     |  3 -
>  drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 18 +++---
>  drivers/staging/rtl8723au/os_dep/os_intfs.c       |  7 +--
>  9 files changed, 101 insertions(+), 122 deletions(-)

Looks good to me

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
