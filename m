Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38477 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab2DYFo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 01:44:28 -0400
Received: by wibhq7 with SMTP id hq7so1400035wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 22:44:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOvK7nDO4fS6R5go+ZXYBqyQc8hhbJGun9Weh=-EyX5k11+tXw@mail.gmail.com>
References: <CAOvK7nAOHqKC8rpFDqGnW7NLCX-G2+syRGih_rv7N5O5rfOUdA@mail.gmail.com>
	<CANUX_P1t8XJOka-QGzZSYFHb6MLc7rm4madn059Yg4b6hJB49A@mail.gmail.com>
	<CAOvK7nDO4fS6R5go+ZXYBqyQc8hhbJGun9Weh=-EyX5k11+tXw@mail.gmail.com>
Date: Wed, 25 Apr 2012 08:44:27 +0300
Message-ID: <CANUX_P2rzvDCBVLmU2rfaZmUOCMuMDe5=TXE_jwxq4ULrvc=QQ@mail.gmail.com> (sfid-20120425_074432_406941_C107F455)
Subject: Re: iwlwifi bug
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: dchyan@princeton.edu
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ list again

On Wed, Apr 25, 2012 at 08:39, Daniel Chyan <dchyan@princeton.edu> wrote:
> The warning appears to occur when there are multiple APs. (Under the
> circumstances, there were some 100 APs.) Going through my kern.log, it
> looks like there are 9 instances of this warning over the span of 2
> days. I can try to provide more details around when it occurs if
> necessary.
>

ok, can you please run with the module parameter: debug=0x80000000

thanks
