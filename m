Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:47886 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751138AbdJNWPB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Oct 2017 18:15:01 -0400
Received: by mail-wm0-f51.google.com with SMTP id t69so27050512wmt.2
        for <linux-wireless@vger.kernel.org>; Sat, 14 Oct 2017 15:15:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171014210036.29556-1-sergey.matyukevich.os@quantenna.com>
References: <20171014210036.29556-1-sergey.matyukevich.os@quantenna.com>
From: Steve deRosier <derosier@gmail.com>
Date: Sat, 14 Oct 2017 15:15:00 -0700
Message-ID: <CALLGbR+DonvXRDysZGx3fJ0wGQsmnWNW3db7mv9KObwTcicnOg@mail.gmail.com> (sfid-20171015_001505_406655_91CEBA38)
Subject: Re: [PATCH] iw: add command to register and capture mgmt frames
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sergey,

On Sat, Oct 14, 2017 at 2:00 PM, Sergey Matyukevich
<sergey.matyukevich.os@quantenna.com> wrote:
> Add new command to register for receiving multiple mgmt frames,
> capture and print them. Frames are selected by their type and
> pattern containing their the first several bytes of the frame
> that should match.
>

Forgive me for asking, what does this provide that isn't already
available in tshark? And since we already have user-space tools
tailored for capturing and filtering any frames, including management
frames, why do we need to add this to iw?

- Steve
