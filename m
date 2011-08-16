Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:37792 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1HPA6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 20:58:48 -0400
Received: by iye16 with SMTP id 16so8513558iye.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2011 17:58:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFHVRfdha1e-+E+hTKPv2JAu5ywOkNo+we2k5FUGtdtRDTV4Aw@mail.gmail.com>
References: <CAFHVRfdha1e-+E+hTKPv2JAu5ywOkNo+we2k5FUGtdtRDTV4Aw@mail.gmail.com>
Date: Tue, 16 Aug 2011 02:58:47 +0200
Message-ID: <CAAd0S9D_NKtSM8NjmYEp4EyXeQpEv5Esu68-qQx1EimeMfHz2Q@mail.gmail.com> (sfid-20110816_025851_997626_9A2B7BAA)
Subject: Re: Problem Building carl9170
From: Christian Lamparter <chunkeey@googlemail.com>
To: Panu Avakul <avakulpa@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, August 16, 2011 02:14:01 AM Panu Avakul wrote:
> I was trying to build carl9170 firmware from the source on the
> git repository. The toolchain build with no problem. However,
> when I run autogen.sh it give me a cmake error message
> CMake Error: Parse error in cache file ...config/CMakeCache.txt.
> I tried deleting it and re run autogen.sh but still no different.
> I was wondering if any one had similar problem and any advice on
> how I should resolve it. I am running this on ubuntu 11.04
No? You are the first to report an issue. However, I wonder what
happened to the "offending entry" line.

Regards,
	Chr
