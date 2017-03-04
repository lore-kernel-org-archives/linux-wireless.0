Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:34632 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752510AbdCDWsS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Mar 2017 17:48:18 -0500
MIME-Version: 1.0
In-Reply-To: <1488471247-11820-1-git-send-email-geo.emmnl@gmail.com>
References: <1488471247-11820-1-git-send-email-geo.emmnl@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 5 Mar 2017 09:47:56 +1100
Message-ID: <CAGRGNgXuUNZmKVAT0xODieXQo=PeNOga9W52p1FGvXSysmpBMA@mail.gmail.com> (sfid-20170304_234840_976800_72EC4DB9)
Subject: Re: [PATCH] Staging:wilc1000:linux_wlan: Modified the 'if-else' statement
To: Georgios Emmanouil <geo.emmnl@gmail.com>
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Fri, Mar 3, 2017 at 3:14 AM, Georgios Emmanouil <geo.emmnl@gmail.com> wrote:
> Modified the 'if-else' statement to make it more readable.
>
> Signed-off-by: Georgios Emmanouil <geo.emmnl@gmail.com>

Again, I'm dubious if this is needed or helpful, but

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  drivers/staging/wilc1000/linux_wlan.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
