Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:58715 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab0CXMMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 08:12:14 -0400
Received: by fxm23 with SMTP id 23so3013261fxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Mar 2010 05:12:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <33a0299c1003240143l23ecb9d4j8978ea585c50a0a2@mail.gmail.com>
References: <33a0299c1003240143l23ecb9d4j8978ea585c50a0a2@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 24 Mar 2010 13:11:53 +0100
Message-ID: <69e28c911003240511l52ff05fdx38d1610ce9609bc5@mail.gmail.com>
Subject: Re: ath9k: packets sent twice 1Mbps & 54Mbps
To: Anthony <lazugau@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 24, 2010 at 9:43 AM, Anthony <lazugau@gmail.com> wrote:
> Hi all,
> I'm using:
> Ubuntu 9.10
> Atheros card with ath9k
> compat-wireless latest stable version
> ad-hoc 802.11g with 2 nodes (same hardware & software configuration)
>
> I tried to inject packets using mac80211 (similar way as in packetspammer)
> Radiotap header contains only Flag=0 & Rate=1Mbps (total size = 14 bytes)
> However when I use wireshark to capture traffic, I discovered that
> each frame was sent twice:
> first time with 14 bytes radiotap header
> second time with 13 bytes of radiotap header (Rate omitted), so 54Mbps here.

Are you sure it is not the AP relaying the packet?

>
> Is this a problem of ath9k or a default feature of 802.11 ???
>
> Another question: if I set the FCS flag to send frame with all zeros
> FCS, the receiver reported frame as bad FCS, but still deliver it to
> upper layer. Why? I think the frame should be discarded ? I want to
> simulate broken phy link by jamming FCS. Is there any alternative way
> ?
>
> Hope some one can help.
>
> Thank you.
>
> Anthony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
