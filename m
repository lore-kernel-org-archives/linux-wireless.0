Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f178.google.com ([74.125.82.178]:35843 "EHLO
        mail-ot0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755098AbeDDCi2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 22:38:28 -0400
MIME-Version: 1.0
In-Reply-To: <afdf0498-c0a9-936c-0c9b-1b6da6eb5957@lwfinger.net>
References: <CA+A7VXX+z8FrDhzW2BQ6AGMJ=_j_53wkUL_YNgkreEbWSh+jCw@mail.gmail.com>
 <afdf0498-c0a9-936c-0c9b-1b6da6eb5957@lwfinger.net>
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date: Tue, 3 Apr 2018 19:37:47 -0700
Message-ID: <CA+A7VXWjWaSSUiX3h_rpFXrSwtUkynKR9tpvnsSe=DZrC+mF-Q@mail.gmail.com> (sfid-20180404_043848_736334_0E0EF75A)
Subject: Re: RTL8723BE performance regression
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>,
        Steven Ting <steventing@realtek.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Drake <drake@endlessm.com>,
        =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>,
        linux@endlessm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 3, 2018 at 7:28 PM, Larry Finger <Larry.Finger@lwfinger.net> wr=
ote:

(...)

> As the antenna selection code changes affected your first bisection, do y=
ou
> have one of those HP laptops with only one antenna and the incorrect codi=
ng
> in the FUSE?

Yes, that is why I've been passing ant_sel=3D1 during my tests -- this
was needed to achieve a good performance in the past, before this
regression. I've also opened the laptop chassis and confirmed the
antenna cable is plugged to the connector labeled with "1" on the
card.

> If so, please make sure that you still have the same signal
> strength for good and bad cases. I have tried to keep the driver and the
> btcoex code in sync, but there may be some combinations of antenna
> configuration and FUSE contents that cause the code to fail.
>

What is the recommended way to monitor the signal strength?

Thanks for such a quick reply,

--
Jo=C3=A3o Paulo Rechi Vita
http://about.me/jprvita
