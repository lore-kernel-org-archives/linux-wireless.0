Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:38046 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYJAUpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 16:45:47 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Kl8Zt-0005HJ-C3
	for linux-wireless@vger.kernel.org; Wed, 01 Oct 2008 20:45:45 +0000
Received: from adsl-dyn239.78-99-97.t-com.sk ([78.99.97.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 20:45:45 +0000
Received: from trigves by adsl-dyn239.78-99-97.t-com.sk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 20:45:45 +0000
To: linux-wireless@vger.kernel.org
From: Trigve <trigves@yahoo.com>
Subject: Re: intel wifi 5100 (iwlagn) authentication timed out
Date: Wed, 1 Oct 2008 20:45:36 +0000 (UTC)
Message-ID: <loom.20081001T204014-448@post.gmane.org> (sfid-20081001_224551_992379_8B04A474)
References: <loom.20081001T181402-749@post.gmane.org>  <43e72e890810011142r62f8cbf2mfdb6bc2a0a2a7bbc@mail.gmail.com>  <loom.20081001T185846-857@post.gmane.org> <43e72e890810011218q501e773dx7544cc355c47438c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@...> writes:
> I hate to ask but are you sure Network Manager and wpa_supplicant were
> not running? Did you check ps -ef ? Anyway, yes please upgrade your
> kernel. Unless of course you wish to help move compat-wireless-old
> move forward and help hack it to work.
> 
>   Luis
> --

So I've tried with 2.6.26.5 kernel but without succes (But as I think about it
now it looks like there aren't some big differences using 2.6.25 and .26
kernel). Can I somehow help to get it working with compat-wireless-old?

thanks

Trigve



