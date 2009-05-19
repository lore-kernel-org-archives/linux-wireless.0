Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([204.127.217.101]:42791 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbZESSc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 14:32:29 -0400
Message-ID: <4A12FB24.40408@lwfinger.net>
Date: Tue, 19 May 2009 13:32:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Andrey Yurovsky <yurovsky@gmail.com>,
	Wladimir Hirnij <counter-strike@bk.ru>,
	linux-wireless@vger.kernel.org
Subject: Re: 
References: <E1M5voF-0003wt-00.counter-strike-bk-ru@f144.mail.ru> 	<45e8e6c40905181614i20c330b8sc982b0acc565708a@mail.gmail.com> <69e28c910905191014o5ac0f99ard03f3750ec6a4f0c@mail.gmail.com>
In-Reply-To: <69e28c910905191014o5ac0f99ard03f3750ec6a4f0c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> Decoded version:
> 
> The rtl8187se is not supported by the mainline driver.  There's a
> driver for it in staging though, and there's a vendor driver hosted
> here:
> http://code.google.com/p/msi-wind-linux/
> ...I would try to build and load that driver for now.

The driver in staging _IS_ the vendor driver with a leak in the procfs fixed and
the code brought up to the latest kernels. It will work. There is no need to use
the vendor driver and to redo those fixes.

I am working on an rtl8187se driver that uses mac80211 and that will be suitable
to be included in mainline kernels. I estimate that I am about 25% done.

Larry
