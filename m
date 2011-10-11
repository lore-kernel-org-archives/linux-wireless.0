Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:39815 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913Ab1JKJsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 05:48:30 -0400
Received: by mail-gy0-f170.google.com with SMTP id 11so6386712gyb.15
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 02:48:29 -0700 (PDT)
Message-ID: <4E9410F9.8070509@ti.com> (sfid-20111011_114834_329947_2C31F1FF)
Date: Tue, 11 Oct 2011 11:48:41 +0200
From: Victor Goldenshtein <victorg@ti.com>
Reply-To: victorg@ti.com
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>, Luciano Coelho <coelho@ti.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 21/29] wl12xx: add band field to wlvif
References: <1318234397-21081-1-git-send-email-eliad@wizery.com> <1318234397-21081-22-git-send-email-eliad@wizery.com> <1318279138.9690.421.camel@cumari> <CAB3XZEf+YgQMdsduXb1eL5r_E+A-Y0EdyP-4map4ZqmQbLTweA@mail.gmail.com>
In-Reply-To: <CAB3XZEf+YgQMdsduXb1eL5r_E+A-Y0EdyP-4map4ZqmQbLTweA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/10/2011 22:47, Eliad Peller wrote:
> On Mon, Oct 10, 2011 at 10:38 PM, Luciano Coelho<coelho@ti.com>  wrote:
>> On Mon, 2011-10-10 at 10:13 +0200, Eliad Peller wrote:

> (otoh, wl12xx_roc is usually get called along with start_role_dev. i
> have some pending patch that couples them together and cleans the code
> a bit. i'll send it soon).
>
> Eliad.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Guys,

Just fyi we will use the roc/croc also in DFS implementation.

Thanks,
Victor.
