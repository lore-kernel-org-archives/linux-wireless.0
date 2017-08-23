Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56880 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753142AbdHWD6N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 23:58:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: Romain Perier <romain.perier@collabora.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        jeffrey.t.kirsher@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v12 7/8] wireless: ipw2200: Replace PCI pool old API
References: <CA++WF2MAT3aHd3TYfLgym9ssFKBsti6+t9b1yJ_eXHEmRBWwcQ@mail.gmail.com>
Date: Wed, 23 Aug 2017 06:58:03 +0300
In-Reply-To: <CA++WF2MAT3aHd3TYfLgym9ssFKBsti6+t9b1yJ_eXHEmRBWwcQ@mail.gmail.com>
        (Stanislav Yakovlev's message of "Tue, 22 Aug 2017 18:11:14 -0400")
Message-ID: <87inhfx7ec.fsf@kamboji.qca.qualcomm.com> (sfid-20170823_055839_433954_060C1C8F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

Stanislav Yakovlev <stas.yakovlev@gmail.com> writes:

> On 22 August 2017 at 07:47, Romain Perier <romain.perier@collabora.com> wrote:
>> The PCI pool API is deprecated. This commit replaces the PCI pool old
>> API by the appropriate function with the DMA pool API.
>>
>> Signed-off-by: Romain Perier <romain.perier@collabora.com>
>> Reviewed-by: Peter Senna Tschudin <peter.senna@collabora.com>
>> ---
>>  drivers/net/wireless/intel/ipw2x00/ipw2200.c | 13 +++++++------
>>  1 file changed, 7 insertions(+), 6 deletions(-)
>>
>
> Acked-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
>
> Thanks, and sorry for the long review.
>
> Kalle, could you please apply it to the wireless-drivers-next tree?

It was not sent to linux-wireless so patchwork didn't see it and hence
it's not on my queue. Please resend.

[1] https://patchwork.kernel.org/project/linux-wireless/list/

-- 
Kalle Valo
