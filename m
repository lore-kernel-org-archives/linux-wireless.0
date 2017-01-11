Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:33404 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752794AbdAKLKl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 06:10:41 -0500
Received: by mail-pf0-f170.google.com with SMTP id y143so40967669pfb.0
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2017 03:10:41 -0800 (PST)
Subject: Re: [REGRESSION, bisect] mesh: SAE connection causes kernel crash
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Cedric.Izoard@ceva-dsp.com
References: <b72bc51c-1873-6178-9990-7d9e99ee4b88@gmail.com>
 <1484121737.23671.0.camel@sipsolutions.net>
 <aa60ffb2-b756-b807-4976-20f2eca6665d@gmail.com>
 <1484125220.23671.1.camel@sipsolutions.net>
 <12d8a797-6c51-4a79-2820-1f9e2e72b2f5@gmail.com>
 <1484128809.23671.11.camel@sipsolutions.net>
 <670a7439-50b9-4f07-1d7d-cb915547562e@gmail.com>
 <1484132519.23671.12.camel@sipsolutions.net>
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <1dd6e9f3-5ad2-1138-8017-c0ab208d9f88@gmail.com> (sfid-20170111_121045_992589_9DE72DE1)
Date: Wed, 11 Jan 2017 20:10:38 +0900
MIME-Version: 1.0
In-Reply-To: <1484132519.23671.12.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017年01月11日 20:01, Johannes Berg wrote:
> Sure, ssh won't - I was thinking of netconsole:
> https://www.kernel.org/doc/Documentation/networking/netconsole.txt

Oh, I see. Thanks, I will try.

Masashi Honma.
