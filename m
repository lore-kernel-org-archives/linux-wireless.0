Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:56564 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab3IJOLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 10:11:45 -0400
Received: by mail-ie0-f179.google.com with SMTP id e14so1679297iej.24
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2013 07:11:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378795155.4799.40.camel@porter.coelho.fi>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	<1378218848-7853-5-git-send-email-eliad@wizery.com>
	<1378795155.4799.40.camel@porter.coelho.fi>
Date: Tue, 10 Sep 2013 16:11:44 +0200
Message-ID: <CAB3XZEf5fJqUxLq7xv0YvWLd1r+PXxZYCo-n_mn6Jj+pLC=i_w@mail.gmail.com> (sfid-20130910_161148_598672_2E8BA4EE)
Subject: Re: [PATCH 05/12] wl18xx: increase the number of allowed BA sessions
From: Eliad Peller <eliad@wizery.com>
To: Luca Coelho <luca@coelho.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 9:39 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
>> From: Victor Goldenshtein <victorg@ti.com>
>>
>> The current fw (actually starting from fw 8.5.0.0.58)
>> supports 8 rx BA sessions.
>>
>> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> The latest firmware version published at linux-firmware.git is
> 8.5.0.0.55 (wl18xx-fw-2.bin), so this patch cannot be taken into the
> official tree yet.
>
> Please publish a newer version of the firmware (with appropriate
> increase in the filename version), since I cannot do that myself
> anymore.
>
you're right.
i'll check with fw guys what fw should be upstreamed.
please drop this patch for now, and let's continue only with the other
patches (that don't require a new fw, afaict).

thanks,
Eliad.
