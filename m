Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42760 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab2JMLuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2012 07:50:18 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so315767vcb.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2012 04:50:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1350037696-23747-2-git-send-email-arend@broadcom.com>
References: <1350037696-23747-1-git-send-email-arend@broadcom.com>
	<1350037696-23747-2-git-send-email-arend@broadcom.com>
Date: Sat, 13 Oct 2012 15:50:17 +0400
Message-ID: <CA++WF2P-oYou49o9Ujb5JkXyN4aYCZA8nG3-BR_76nVrCTpopA@mail.gmail.com> (sfid-20121013_135027_723561_DAA80E8D)
Subject: Re: [PATCH 1/3] wireless: drivers: make use of WLAN_EID_VENDOR_SPECIFIC
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>, Jouni Malinen <j@w1.fi>,
	Dan Williams <dcbw@redhat.com>, Bing Zhao <bzhao@marvell.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On 12 October 2012 14:28, Arend van Spriel <arend@broadcom.com> wrote:
> The include file linux/ieee80211.h contains three definitions for
> the same thing in enum ieee80211_eid due to historic changes:
>
> /* Information Element IDs */
> enum ieee80211_eid {
>     :
>     WLAN_EID_WPA = 221,
>     WLAN_EID_GENERIC = 221,
>     WLAN_EID_VENDOR_SPECIFIC = 221,
>     :
> };
>
> The standard refers to this as "vendor specific" element so the
> other two definitions are better not used. This patch changes the
> wireless drivers to use one definition, ie. WLAN_EID_VENDOR_SPECIFIC.
>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: Jouni Malinen <j@w1.fi>
> Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> Cc: Dan Williams <dcbw@redhat.com>
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

For the ipw2x00 part:

Acked-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>

Thanks!
Stanislav.
