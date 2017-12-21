Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59906 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752013AbdLUKiq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 05:38:46 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>
Cc: Luca Coelho <luca@coelho.fi>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        it+linux-wireless@molgen.mpg.de
Subject: Re: UBSAN: Undefined behaviour in drivers/net/wireless/intel/iwlwifi/mvm/utils.c:838:5
References: <75bc638e-99a8-2f3f-6260-491f8a018af6@molgen.mpg.de>
        <1513175552.4827.365.camel@intel.com>
        <1513621815.4827.430.camel@coelho.fi>
        <a08aa1b3-9d75-2f38-a0f0-aefe181137da@molgen.mpg.de>
Date: Thu, 21 Dec 2017 12:38:41 +0200
In-Reply-To: <a08aa1b3-9d75-2f38-a0f0-aefe181137da@molgen.mpg.de> (Paul
        Menzel's message of "Wed, 20 Dec 2017 12:00:48 +0100")
Message-ID: <87r2ro9xhq.fsf@purkki.adurom.net> (sfid-20171221_113853_059771_358F48ED)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de> writes:

>> http://pastebin.coelho.fi/7b624f474846da52.txt
>
> Thank you. The warning is gone now. Thank you. For the next time, it=E2=
=80=99d
> be great to provide the output of `git format-patch -1`, which can be
> applied with `git am`. The output of `git show` is with my knowledge
> hard to apply.

'patch -p1 < foo.patch' should work. Of course it omits the commit log
but is usually enough for testing purposes.

--=20
Kalle Valo
