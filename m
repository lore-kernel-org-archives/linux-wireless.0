Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:41776 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1HPDx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 23:53:28 -0400
Received: by iye16 with SMTP id 16so8759908iye.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2011 20:53:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAd0S9D_NKtSM8NjmYEp4EyXeQpEv5Esu68-qQx1EimeMfHz2Q@mail.gmail.com>
References: <CAFHVRfdha1e-+E+hTKPv2JAu5ywOkNo+we2k5FUGtdtRDTV4Aw@mail.gmail.com>
	<CAAd0S9D_NKtSM8NjmYEp4EyXeQpEv5Esu68-qQx1EimeMfHz2Q@mail.gmail.com>
Date: Mon, 15 Aug 2011 20:53:27 -0700
Message-ID: <CAFHVRfcUANEJpG6y+XYw_6SYFdxGG8S+Zf3YU+6257KQP9P3Pw@mail.gmail.com> (sfid-20110816_055331_719221_C56AE557)
Subject: Re: Problem Building carl9170
From: Panu Avakul <avakulpa@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, thank you for your reply,
I'm not sure if this is the correct method to reply to a mailing list,
but I have not used a lot of mailing list before.
There was the offending entry line, however it shown some person name
and his email address so I didn't think it was appropriate to include
in the mail.
I'll keep trying to see what went wrong.  If anyone happen to have any
ideas what went wrong please let me know.
Best Regard
Panu

On Mon, Aug 15, 2011 at 5:58 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Tuesday, August 16, 2011 02:14:01 AM Panu Avakul wrote:
>> I was trying to build carl9170 firmware from the source on the
>> git repository. The toolchain build with no problem. However,
>> when I run autogen.sh it give me a cmake error message
>> CMake Error: Parse error in cache file ...config/CMakeCache.txt.
>> I tried deleting it and re run autogen.sh but still no different.
>> I was wondering if any one had similar problem and any advice on
>> how I should resolve it. I am running this on ubuntu 11.04
> No? You are the first to report an issue. However, I wonder what
> happened to the "offending entry" line.
>
> Regards,
>        Chr
>
