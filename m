Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:42368 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab0HHFIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Aug 2010 01:08:48 -0400
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Interesting development regarding b43 DMA ERROR
References: <4C5B27BE.8010708@lwfinger.net>
	<AANLkTi=-Jc9XjD-gqwtUyUnM768wvv3GzzwhJNtkwYKK@mail.gmail.com>
	<4C5C4860.2030507@lwfinger.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 08 Aug 2010 08:08:46 +0300
In-Reply-To: <4C5C4860.2030507@lwfinger.net> (Larry Finger's message of "Fri\, 06 Aug 2010 12\:37\:36 -0500")
Message-ID: <878w4hd735.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 08/06/2010 11:31 AM, Rafał Miłecki wrote:
>> 
>> Interesting. It means some patch that gone mainline fixed it and it
>> was submitted using other tree than w-t, right?
>> 
>> Would you care to bisect this?
>
> It won't be fun as this is a 1.6 GHz Atom and a kernel build is quite slow.

You can always build the kernel in another machine and just copy the
zImage and modules back to your netbook (or even create a monolithic
kernel without any modules). Also there are tools like distcc and
ccache which would help.

-- 
Kalle Valo
