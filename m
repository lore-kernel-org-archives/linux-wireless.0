Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:34337 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbbI3Kpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 06:45:52 -0400
Received: by ykdg206 with SMTP id g206so35184452ykd.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2015 03:45:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150930102034.GA6737@kroah.com>
References: <1443603134-11582-1-git-send-email-chaehyun.lim@gmail.com>
	<20150930102034.GA6737@kroah.com>
Date: Wed, 30 Sep 2015 19:45:51 +0900
Message-ID: <CAKV=istXrAJOeZN-=tX5Ac+WD=a0SRRo5mGPELVAx9EccS-JZw@mail.gmail.com> (sfid-20150930_124600_714510_4DBD86C5)
Subject: Re: [PATCH] staging: wilc1000: fix build error for openrisc-allmodconfig
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	"tony.cho" <tony.cho@atmel.com>, leo.kim@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2015 at 7:20 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Sep 30, 2015 at 05:52:14PM +0900, Chaehyun Lim wrote:
>> The kbuild test robot reports the following build error for
>> openrisc-allmodconfig.
>>
>> >> drivers/staging/wilc1000/wilc_sdio.c:584:2: error: implicit
>> >> declaration of function 'memset'
>>
>> The error occurs due to missing a standard header file as
>> <linux/string.h> so that three .c files are included it.
>>
>> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
>
> You forgot to add a Reported-by: line giving credit to kbuild, I've done
> that by hand.
>
> thanks,
>
> greg k-h

I understood. I will keep it in my mind to send patch.

Regards
Chaehyun Lim
