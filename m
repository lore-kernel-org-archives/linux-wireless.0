Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:47797 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZGaTGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 15:06:11 -0400
Received: by gxk9 with SMTP id 9so4013838gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 12:06:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A733FFD.60407@candelatech.com>
References: <20090731180805.GD7963@makis> <4A733FFD.60407@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 31 Jul 2009 12:05:51 -0700
Message-ID: <43e72e890907311205x607b33f4v93fd34ba75521747@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 3/4] ath5k: Wakeup fixes
To: Ben Greear <greearb@candelatech.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 12:03 PM, Ben Greear<greearb@candelatech.com> wrote:
> On 07/31/2009 11:08 AM, Nick Kossifidis wrote:
>>
>>  * Don't put chip to full sleep because there are problems during
>>    wakeup. Instead hold MAC/Baseband on warm reset state via a new
>>    function ath5k_hw_on_hold.
>>
>>  * Durring attach preserve pcicfg bits when enabling pci core
>>    sw retry fix.
>>
>>  * Minor cleanups
>
> I patched just this patch (not your other 3) into 2.6.31-rc4 and it seems
> to fix the wakeup problems I was seeing on module unload/load.

And now you can throw in a Tested-by in the commit log. The commit log
will make more sense as if you refer to the issue we can refer to it
later in the future and see it was tested perhaps by the same user who
reported the issue.

  Luis
