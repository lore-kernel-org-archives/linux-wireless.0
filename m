Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33791 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbdCDWtX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Mar 2017 17:49:23 -0500
MIME-Version: 1.0
In-Reply-To: <1488468905-8686-1-git-send-email-geo.emmnl@gmail.com>
References: <1488468905-8686-1-git-send-email-geo.emmnl@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 5 Mar 2017 09:49:01 +1100
Message-ID: <CAGRGNgXV4qecHWcFJd9knbJ5rSQAZzE2zRVD7U2DBuHkPOkh4A@mail.gmail.com> (sfid-20170304_234949_057804_A342664F)
Subject: Re: [PATCH 1/3] Staging:wilc1000:host_interface: Removed unnecessary
 blank line
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

On Fri, Mar 3, 2017 at 2:35 AM, Georgios Emmanouil <geo.emmnl@gmail.com> wrote:
> Removed unnecessary blank line.
>
> Signed-off-by: Georgios Emmanouil <geo.emmnl@gmail.com>

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  drivers/staging/wilc1000/host_interface.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index c307cce..090fd43 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -287,7 +287,6 @@ static int wilc_enqueue_cmd(struct host_if_msg *msg)
>         return 0;
>  }
>
> -
>  /* The u8IfIdx starts from 0 to NUM_CONCURRENT_IFC -1, but 0 index used as
>   * special purpose in wilc device, so we add 1 to the index to starts from 1.
>   * As a result, the returned index will be 1 to NUM_CONCURRENT_IFC.
> --
> 2.1.4
>



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
