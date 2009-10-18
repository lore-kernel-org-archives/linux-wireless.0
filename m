Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:2518 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbZJRNCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2009 09:02:47 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1041497fga.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2009 06:02:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255861930.5093.7.camel@chriss-imac>
References: <1255861930.5093.7.camel@chriss-imac>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 18 Oct 2009 15:02:30 +0200
Message-ID: <69e28c910910180602qe4cdb1fy5c2ec3f6dae0c146@mail.gmail.com>
Subject: Re: Support for Broadcom's BCM4328 chip
To: Chriss Kalogeropoulos <iz.iznogood@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 18, 2009 at 12:32 PM, Chriss Kalogeropoulos
<iz.iznogood@gmail.com> wrote:
> Hello,
>
> i have an i-mac using Broadcom's BCM4328 chip.
>
> lspci gives:
>
> 03:00.0 Network controller [0280]: Broadcom Corporation BCM4328
> 802.11a/b/g/n [14e4:4328] (rev 01)
>
> This must have been answered before but i thought to ask in case
> something has changed. Any hope on getting support on that chip with an
> open source driver ?
>
> Please cc me since i am not a subscriber on the list.
>
> Thanks in advance
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

This is an N-PHY card. Reverse-engineering of N-PHY cards is still in
progress (though it is finally really "in progress", and not stalled
anymore), and it needs to be finished (at least the G part) before we
can work on implementing it.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
