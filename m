Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:39618 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbYHJWNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2008 18:13:52 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3463287wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2008 15:13:51 -0700 (PDT)
Message-ID: <69e28c910808101513y10b58434of93a095b69771ca3@mail.gmail.com> (sfid-20080811_001356_370304_FD1CBEFB)
Date: Mon, 11 Aug 2008 00:13:51 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: postfix@au-79.de
Subject: Re: Problems with Belkin F5D7010 PCMCIA 1799:701f while trying WPA connection
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <489F5158.9090705@au-79.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <489EAA04.8070203@au-79.de> <489EF765.8050000@lwfinger.net>
	 <489F5158.9090705@au-79.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 10, 2008 at 10:36 PM, Robert Goldner <postfix@au-79.de> wrote:
> Hi Larry,
>
> very good point. There is a German saying like:
> "who is able to read, has clear advantages..."
>
> The ifconfig output seems good (like other working wlan cards), and the
> interface is up. But iwlist wlan0 scan does not find any wlan-network. Very
> strange, because I made this test very close to the access-point (about 30
> cm distance). With other wlan-cards I get signal levels of ~80% of maximum.
> So maybe the receiving part is broken. I can not test the hardware with the
> windows-driver, because I don't have a windows-installation.
>
>
> Robert

Can you try using the windows driver with ndiswrapper? That should
also reveal if the card is broken.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
