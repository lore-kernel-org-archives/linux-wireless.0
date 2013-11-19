Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:63311 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3KSCVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 21:21:07 -0500
Received: by mail-ob0-f181.google.com with SMTP id uz6so8031255obc.12
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 18:21:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABGE7dsDtL0ZPAmOTW=G=hMdA-6r=yT0DtQx_-H6Yi6cGa6Udw@mail.gmail.com>
References: <CABGE7dsDtL0ZPAmOTW=G=hMdA-6r=yT0DtQx_-H6Yi6cGa6Udw@mail.gmail.com>
From: Gustavo Azambuja <gazambuja+hostapd@gmail.com>
Date: Tue, 19 Nov 2013 00:20:46 -0200
Message-ID: <CABGE7dur4pM4vLz_iLx7u-g5ohKhXkwKAOmjJ86PE62mYwGPJw@mail.gmail.com> (sfid-20131119_032112_343549_DF62ADFE)
Subject: Re: NL80211_CMD_NEW_STATION result: -105 (No buffer space available)
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I recently installed in my raspberry pi Raspbian with hostapd 1.0, I
want to make my own Hotspot, but follow all tutorials, I can only get up to
6 stations connected at the same time.

The next error apper with the #7 client try to connect:
*NL80211_CMD_NEW_STATION result: -105 (No buffer space available)*

How I can resize this and make more clients can connect to my device?

Im using TL-WN722N dongle.

Thanks in advice!

On Tue, Nov 19, 2013 at 12:17 AM, Gustavo Azambuja
<gazambuja+hostapd@gmail.com> wrote:
> Hi, I recently installed in my raspberry pi Raspbian with hostapd 1.0, I
> want to make my own Hotspot, but follow all tutorials, I can only get up to
> 6 stations connected at the same time.
>
> The next error apper with the #7 client try to connect:
> *NL80211_CMD_NEW_STATION result: -105 (No buffer space available)*
>
> How I can resize this and make more clients can connect to my device?
>
> Im using TL-WN722N dongle.
>
> Thanks in advice!
>
> Gustavo
