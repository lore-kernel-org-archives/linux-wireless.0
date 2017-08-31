Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:32839 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752072AbdHaXtp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 19:49:45 -0400
Received: by mail-wr0-f175.google.com with SMTP id k94so2746441wrc.0
        for <linux-wireless@vger.kernel.org>; Thu, 31 Aug 2017 16:49:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BY1PR0201MB0904426CF17EF719FA343B1C839D0@BY1PR0201MB0904.namprd02.prod.outlook.com>
References: <BY1PR0201MB0904426CF17EF719FA343B1C839D0@BY1PR0201MB0904.namprd02.prod.outlook.com>
From: Steve deRosier <derosier@gmail.com>
Date: Thu, 31 Aug 2017 16:49:43 -0700
Message-ID: <CALLGbRKbKWdo7BeDWUi24iP4OJDh-3WGdxEVBJCuYQ44==pE7g@mail.gmail.com> (sfid-20170901_015000_645771_3574F748)
Subject: Re: [PATCH] Correctly fail to suspend when SDIO does not support
 power on suspend
To: Eric Bentley <Eric.Bentley@lairdtech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 31, 2017 at 4:44 PM, Eric Bentley
<Eric.Bentley@lairdtech.com> wrote:
> -       if (sdio_set_host_pm_flags(sdiodev->func[1], sdio_flags))
> +       if (sdio_set_host_pm_flags(sdiodev->func[1], sdio_flags)) (

Hi Eric,

Shouldn't that be a '{' instead of '('?  Maybe I'm missing some
context, but that doesn't look compilable.

:)

- Steve
