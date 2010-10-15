Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34282 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab0JOOvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 10:51:17 -0400
Received: by ewy20 with SMTP id 20so974970ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 07:51:16 -0700 (PDT)
Message-ID: <4CB86AD5.90205@lwfinger.net>
Date: Fri, 15 Oct 2010 09:53:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/3] b43: N-PHY: define channel table struct for rev3+
 devices
References: <1287090064-14607-1-git-send-email-zajec5@gmail.com>	<AANLkTimnzeRa53g0i2ZkB4Qy_x_P3h4Z+ZwC2HdJPxFC@mail.gmail.com>	<AANLkTinnOm5rg8FKxFct1zKHZZi7k9nxEKtBYkLFktSS@mail.gmail.com>	<AANLkTim==y20jOa6SpvZogZ+0inFGvmpnN-nTKFZp2Xz@mail.gmail.com> <AANLkTimvMCRVLzNjM+vsVEyHHAV0fLF4ABeV_20CdOCa@mail.gmail.com>
In-Reply-To: <AANLkTimvMCRVLzNjM+vsVEyHHAV0fLF4ABeV_20CdOCa@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/2010 09:27 AM, Rafał Miłecki wrote:
> 
> There is "Chapter 12: Macros, Enums and RTL" in:
> http://www.kernel.org/doc/Documentation/CodingStyle
> 
> Some quotes:
> 1) "Macros with multiple statements should be enclosed in a do - while block:"
> 2) "macros defining constants using expressions must enclose the
> expression in parentheses"
> 
> Second one may sound like sth close, but it's just about expressions like:
> #define CONSTEXP (CONSTANT | 3)
> 
> So there doesn't seem to be any "rule" in CodingStyle wanting us to
> add parentheses when you suggested.

I think that scripts/checkpatch would report any definitions that need parentheses.

As you have probably figured out, I'm back home. If you have spec questions ;),
I'm ready.

Larry
