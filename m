Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39044 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab1LENKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 08:10:15 -0500
Received: by ghrr1 with SMTP id r1so4342621ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2011 05:10:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOeh9MuuJtK_edMQvVaLSRytRoFix_OuW4OEcEMDYEak1=CvMw@mail.gmail.com>
References: <CAOeh9MuuJtK_edMQvVaLSRytRoFix_OuW4OEcEMDYEak1=CvMw@mail.gmail.com>
Date: Mon, 5 Dec 2011 15:10:14 +0200
Message-ID: <CAB3XZEf=jrrqZk58BnV8Gi4iKJ6N6c24M_eLnz816n==kuxmHA@mail.gmail.com> (sfid-20111205_141020_367672_2BE5F4F4)
Subject: Re: Query on ieee80211_subif_start_xmit
From: Eliad Peller <eliad@wizery.com>
To: uday kiran <kaniki.uday@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 5, 2011 at 1:55 PM, uday kiran <kaniki.uday@gmail.com> wrote:
>  The function ieee80211_subif_start_xmit description says that it will
>  encapsulate 802.3 frame with 802.11 header and transmit. If yes, what
>  is the function which will decapsulate at the rx end.
>
the 802.11 header replaces the 802.3 header.
i guess the intention was that ieee80211_subif_start_xmit will
encapsulate the frame with 802.11 header after decapsulating the 802.3
header.

Eliad.
