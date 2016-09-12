Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756086AbcILOrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 10:47:11 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: Hanno Zulla <abos@hanno.de>, linux-wireless@vger.kernel.org,
        Larry.Finger@lwfinger.net, anthony.wong@canonical.com
Subject: Re: Support of rtl8723bs
References: <688574b6-1141-f408-d397-535f1f69999e@hanno.de>
        <1473683031.2930.3.camel@hadess.net>
Date: Mon, 12 Sep 2016 10:47:09 -0400
In-Reply-To: <1473683031.2930.3.camel@hadess.net> (Bastien Nocera's message of
        "Mon, 12 Sep 2016 14:23:51 +0200")
Message-ID: <wrfjtwdli39u.fsf@redhat.com> (sfid-20160912_164715_585761_5D288764)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bastien Nocera <hadess@hadess.net> writes:
> On Mon, 2016-09-12 at 11:20 +0200, Hanno Zulla wrote:
>> Hi Jes,
>> hello linux-wireless,
>> it as a guinea pig to test on my hardware. The newer vendor driver
>> crashed on Ubuntu' 4.4 sources and doesn't compile yet on Ubuntu 4.8-
>> rc
>> sources.
>> https://github.com/anthonywong/rtl8723bs/issues/1
>
> I really don't care about the vendor driver. There's no way to track
> changes other than through code dumps.
>
> Longer term, it seems likely that improving Jes' driver is the way to
> go. At least there's 170k less lines of code to read in the rtl8723bs
> driver to get things going.

Longer term I think it makes sense to add SDIO support to rtl8xxxu. The
differences between the USB version and the SDIO version are rather
small.

That said, I have quite a lot of things on my TODO list so it is going
to take some time until I can look at this. It may make sense to pull
a cleaned up version of the vendor driver into staging until then if
there is a desperate need for it, but otherwise any help would be
appreciated :)

Jes
