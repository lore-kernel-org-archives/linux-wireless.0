Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:32922 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760755AbdAKKgN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 05:36:13 -0500
Received: by mail-pg0-f47.google.com with SMTP id 204so27247103pge.0
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2017 02:36:13 -0800 (PST)
Subject: Re: [REGRESSION, bisect] mesh: SAE connection causes kernel crash
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Cedric.Izoard@ceva-dsp.com
References: <b72bc51c-1873-6178-9990-7d9e99ee4b88@gmail.com>
 <1484121737.23671.0.camel@sipsolutions.net>
 <aa60ffb2-b756-b807-4976-20f2eca6665d@gmail.com>
 <1484125220.23671.1.camel@sipsolutions.net>
 <12d8a797-6c51-4a79-2820-1f9e2e72b2f5@gmail.com>
 <1484128809.23671.11.camel@sipsolutions.net>
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <670a7439-50b9-4f07-1d7d-cb915547562e@gmail.com> (sfid-20170111_113618_220244_A3C2924E)
Date: Wed, 11 Jan 2017 19:36:09 +0900
MIME-Version: 1.0
In-Reply-To: <1484128809.23671.11.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017年01月11日 19:00, Johannes Berg wrote:
> Nevertheless, I don't have hardware to try to reproduce it, and I can't
> see any such issues (even with real forwarding, I even just wrote a
> wpa_s test for that) in hwsim.
>
> Even a photo of the crash on the VT would help. Or maybe you can set up
> netconsole on the wired interface?

Thanks but SSH console via wired interface and laptop display does not 
show any log...

Masashi Honma.
