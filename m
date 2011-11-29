Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54461 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014Ab1K2FWP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 00:22:15 -0500
Received: by lahl5 with SMTP id l5so802532lah.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 21:22:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ED3FA65.7010104@aol.com>
References: <4ED3A6E8.4050000@aol.com>
	<CACna6ryNkHeVXWXxFfod1-KQs8HQVv7wF-xpY5MA-Qs6fCypCg@mail.gmail.com>
	<CACna6rzRJgfddE4jPivxBJCCZEyKSHsdRX7cE15rRxk2nhiRkA@mail.gmail.com>
	<4ED3B33E.8020309@lwfinger.net>
	<4ED3FA65.7010104@aol.com>
Date: Tue, 29 Nov 2011 06:22:14 +0100
Message-ID: <CACna6rw1gEjd_hcX=5hLHt0YwUqDaVBs7_MO50GLKeok57YtVw@mail.gmail.com> (sfid-20111129_062219_730320_290EE037)
Subject: Re: Trouble with Macbook Pro 8,2 (broadcom 4331) and latest b43
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: AndrewL733 <AndrewL733@aol.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/28 AndrewL733 <AndrewL733@aol.com>:
> Hi,
>
> Thanks for the suggestions.  Nothing solving the problem so far.
>
> I meant
> find /lib/modules -name "b43.ko"
>
>
> What is the point of looking for b43.ko?  It exists for my running kernel.

I believe b43.ko from compat-wireless should be put in some specific
subdirectory, probably "extra". AFAIR it's
/lib/modules/SOMEKERNEL/extra/...

If you can see only default b43.ko, it means compat-wireless didn't
install successfully.

-- 
Rafał
