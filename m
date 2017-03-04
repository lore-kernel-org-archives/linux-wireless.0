Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:33139 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752103AbdCDWvC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Mar 2017 17:51:02 -0500
MIME-Version: 1.0
In-Reply-To: <1488469085-9033-1-git-send-email-geo.emmnl@gmail.com>
References: <1488469029-8918-1-git-send-email-geo.emmnl@gmail.com> <1488469085-9033-1-git-send-email-geo.emmnl@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 5 Mar 2017 09:50:40 +1100
Message-ID: <CAGRGNgUKbRiimMgKr8cQ_47e6aTQ=OSaaC6WVVxi-_iKP5X=zg@mail.gmail.com> (sfid-20170304_235125_339188_F5F729D6)
Subject: Re: [PATCH 3/3] Staging:wilc1000:host_interface: Integrated two 'if'
 statements to a single 'if' statement
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

On Fri, Mar 3, 2017 at 2:38 AM, Georgios Emmanouil <geo.emmnl@gmail.com> wrote:
> Removed unnecessary 'if' statement and integrated the condition to the
> previous 'if' statement.
>
> Signed-off-by: Georgios Emmanouil <geo.emmnl@gmail.com>

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  drivers/staging/wilc1000/host_interface.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
