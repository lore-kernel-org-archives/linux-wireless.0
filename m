Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sonic305-35.consmr.mail.ir2.yahoo.com ([77.238.177.97]:35164
        "EHLO sonic305-35.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754777AbdHYVFb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2017 17:05:31 -0400
Date: Fri, 25 Aug 2017 21:05:27 +0000 (UTC)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: Hin-Tak Leung <htl10@users.sourceforge.net>
To: <kvalo@codeaurora.org>, <herton@canonical.com>,
        <Larry.Finger@lwfinger.net>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
Message-ID: <1571555159.3124994.1503695127129@mail.yahoo.com> (sfid-20170825_230550_436433_67BE946A)
Subject: Re: [PATCH 31/35] wireless: realtek: rtl8187: constify
 usb_device_id
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1571555159.3124994.1503695127129.ref@mail.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--------------------------------------------
On Tue, 8/8/17, Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:

 Subject: [PATCH 31/35] wireless: realtek: rtl8187: constify usb_device_id
 To: kvalo@codeaurora.org, herton@canonical.com, htl10@users.sourceforge.net, Larry.Finger@lwfinger.net
 Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org
 Date: Tuesday, 8 August, 2017, 17:04
 
> usb_device_id are not supposed to change at
> runtime. All functions
> working with usb_device_id provided by
> <linux/usb.h> work with
> const usb_device_id. So mark the
> non-const structs as const.
 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
 
Acked-by: htl10@users.sourceforge.net
