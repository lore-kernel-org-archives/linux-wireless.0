Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56469 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab1LENOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 08:14:40 -0500
Received: by eaak14 with SMTP id k14so3991273eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2011 05:14:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEf=jrrqZk58BnV8Gi4iKJ6N6c24M_eLnz816n==kuxmHA@mail.gmail.com>
References: <CAOeh9MuuJtK_edMQvVaLSRytRoFix_OuW4OEcEMDYEak1=CvMw@mail.gmail.com>
	<CAB3XZEf=jrrqZk58BnV8Gi4iKJ6N6c24M_eLnz816n==kuxmHA@mail.gmail.com>
Date: Mon, 5 Dec 2011 18:44:39 +0530
Message-ID: <CAOeh9MsqTQT6qzd47Af674cK4KQHN=uOaG-u1hVWV9faeb2Mwg@mail.gmail.com> (sfid-20111205_141446_684217_226A9496)
Subject: Re: Query on ieee80211_subif_start_xmit
From: uday kiran <kaniki.uday@gmail.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the reply, Eliad.

I have walked through the code for function
"ieee80211_subif_start_xmit" but could not find any code block which
strips the 802.3 header. If possible , could you help me point out
that block ?

-Uday

On 12/5/11, Eliad Peller <eliad@wizery.com> wrote:
> On Mon, Dec 5, 2011 at 1:55 PM, uday kiran <kaniki.uday@gmail.com> wrote:
>>  The function ieee80211_subif_start_xmit description says that it will
>>  encapsulate 802.3 frame with 802.11 header and transmit. If yes, what
>>  is the function which will decapsulate at the rx end.
>>
> the 802.11 header replaces the 802.3 header.
> i guess the intention was that ieee80211_subif_start_xmit will
> encapsulate the frame with 802.11 header after decapsulating the 802.3
> header.
>
> Eliad.
>
