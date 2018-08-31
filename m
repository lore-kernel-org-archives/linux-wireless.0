Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:38147 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbeHaR1m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 13:27:42 -0400
MIME-Version: 1.0
References: <20180812145207.11395-1-kristian.evensen@gmail.com>
 <871sb3zc3v.fsf@kamboji.qca.qualcomm.com> <5B708025.4090906@broadcom.com>
 <CAJ0CqmVZNAnHwnU4YqRRv7R8DyHi2MiFJr1bvQDPVszUU5Ez3g@mail.gmail.com>
 <CAKfDRXia3zwW9Q=7RZGqK_DWCsyQzG4KEZHsyHzGcNb70Ge1kA@mail.gmail.com>
 <CAKfDRXjSLpGU6cOBHDdLxoNzaXWmgpYO7E4vjGg-J8AxOZiTyw@mail.gmail.com> <20180831131520.GC6236@localhost.localdomain>
In-Reply-To: <20180831131520.GC6236@localhost.localdomain>
From: Kristian Evensen <kristian.evensen@gmail.com>
Date: Fri, 31 Aug 2018 15:20:03 +0200
Message-ID: <CAKfDRXgVf5F2=gjGTvDK4N9zV=QcKvtDPobvdSkwPsDcjhT6pg@mail.gmail.com> (sfid-20180831_152023_995303_1012BA97)
Subject: Re: [PATCH] mt76: Enable NL80211_EXT_FEATURE_CQM_RSSI_LIST
To: lorenzo.bianconi@redhat.com
Cc: arend.vanspriel@broadcom.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
On Fri, Aug 31, 2018 at 3:15 PM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
> I have not tested your patch yet sorry but there are no differences
> between pcie and usb devices regarding rx RSSI management (both of them use
> shared code for it) so I guess the feature will work on usb devices if
> it works on pcie ones.

Thanks for letting me know. I will submit a v2 with an updated and
more detailed commit message.

BR,
Kristian
