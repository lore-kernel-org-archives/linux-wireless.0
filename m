Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48746 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459Ab0FOLvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 07:51:20 -0400
Received: by iwn9 with SMTP id 9so4430369iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 04:51:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1276593467-28309-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1276593467-28309-1-git-send-email-juuso.oikarinen@nokia.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 15 Jun 2010 21:50:58 +1000
Message-ID: <AANLkTilMwuYujJ1vhVGdoop8ZbgHeJRGcWEYECPLcx-B@mail.gmail.com>
Subject: Re: [RFC PATCH] iw: Add support for setting transmit power
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 15, 2010 at 19:17, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
> This patch adds the "set tx_power" command to allow specifying the transmit
> power level to the WLAN stack. The transmit power configuration consists of
> a mode (automatic, fixed, limited) and the limit mBm value.
>
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
>  Makefile  |    3 ++-
>  nl80211.h |   27 ++++++++++++++++++++++++++-
>  2 files changed, 28 insertions(+), 2 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index d303f45..cbb9504 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -17,7 +17,8 @@ CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
>  OBJS = iw.o genl.o event.o info.o phy.o \
>        interface.o ibss.o station.o survey.o util.o \
>        mesh.o mpath.o scan.o reg.o version.o \
> -       reason.o status.o connect.o link.o offch.o ps.o cqm.o
> +       reason.o status.o connect.o link.o offch.o ps.o cqm.o \
> +       txpower.o
>  OBJS += sections.o
>  ALL = iw
>

Call me stupid, but is there a txpower.c?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
