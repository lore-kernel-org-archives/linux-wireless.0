Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:60396 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab3EVUUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 16:20:39 -0400
Received: by mail-ie0-f181.google.com with SMTP id x12so6067539ief.26
        for <linux-wireless@vger.kernel.org>; Wed, 22 May 2013 13:20:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P1zU-ntkdb33taPz=0qw2Xy-bp3jdA-C7eqXX-wbebMGA@mail.gmail.com>
References: <CAP8Jb=oTE_tL+57_wtMo_QTNG01_oP2jgjicrDneFwTuOocs8g@mail.gmail.com>
 <CANUX_P1zU-ntkdb33taPz=0qw2Xy-bp3jdA-C7eqXX-wbebMGA@mail.gmail.com>
From: Flavio <fbcyborg@gmail.com>
Date: Wed, 22 May 2013 22:20:19 +0200
Message-ID: <CAP8Jb=qS+ty7U6AcQLH+PYUBy5OZdNVrbsg4fq7g24C7VmUFow@mail.gmail.com> (sfid-20130522_222043_088712_955F18DF)
Subject: Re: Problem with iwlwifi kernel 3.9.0 and 3.9.2
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2013 10:17, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>
> Please try the patch attached in
> https://bugzilla.kernel.org/show_bug.cgi?id=58341
Thank you.
I applied the patch and now the connection was immediate.
It's strange because the problem I've reported didn't happen the first
time I booted the OS,
even before applying the patch. So I will test this patch starting
from now and I will report
any issue if appropriate.

Thanks!

-- 
Flavio
