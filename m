Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64950 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab0HFRhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 13:37:32 -0400
Received: by vws3 with SMTP id 3so6327022vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 10:37:31 -0700 (PDT)
Message-ID: <4C5C4860.2030507@lwfinger.net>
Date: Fri, 06 Aug 2010 12:37:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Interesting development regarding b43 DMA ERROR
References: <4C5B27BE.8010708@lwfinger.net> <AANLkTi=-Jc9XjD-gqwtUyUnM768wvv3GzzwhJNtkwYKK@mail.gmail.com>
In-Reply-To: <AANLkTi=-Jc9XjD-gqwtUyUnM768wvv3GzzwhJNtkwYKK@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/06/2010 11:31 AM, Rafał Miłecki wrote:
> 
> Interesting. It means some patch that gone mainline fixed it and it
> was submitted using other tree than w-t, right?
> 
> Would you care to bisect this?

It won't be fun as this is a 1.6 GHz Atom and a kernel build is quite slow. In
addition, this one has the relocated SPROM that requires patching to be able to
boot. In the interests of the community, I will do it.

Larry
