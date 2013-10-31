Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50434 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3JaPtD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 11:49:03 -0400
Received: by mail-ie0-f174.google.com with SMTP id qd12so5273897ieb.5
        for <linux-wireless@vger.kernel.org>; Thu, 31 Oct 2013 08:49:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1383233873.6949.YahooMailNeo@web171806.mail.ir2.yahoo.com>
References: <1382537927.62604.YahooMailNeo@web171801.mail.ir2.yahoo.com>
	<1382538469.7892.YahooMailNeo@web171805.mail.ir2.yahoo.com>
	<20131024112206.GB1677@redhat.com>
	<1382614336.89589.YahooMailNeo@web171804.mail.ir2.yahoo.com>
	<20131024113748.GD1677@redhat.com>
	<1383227814.41997.YahooMailNeo@web171801.mail.ir2.yahoo.com>
	<527264F6.2030001@hauke-m.de>
	<1383233873.6949.YahooMailNeo@web171806.mail.ir2.yahoo.com>
Date: Thu, 31 Oct 2013 16:49:01 +0100
Message-ID: <CAL1gcdNyW-Z7YkQYsbpbxr+zdoXnoE9KcZi9E1q0SoVOV6LQ_A@mail.gmail.com> (sfid-20131031_164910_153640_E7C7FEB7)
Subject: Re: Edimax EW-7733UnD
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Gianfranco Costamagna <costamagnagianfranco@yahoo.it>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 31, 2013 at 4:37 PM, Gianfranco Costamagna
<costamagnagianfranco@yahoo.it> wrote:
>
>>Aren't you trying to get a RT3573 card to work? You should activate
>>CONFIG_RT2800USB_RT3573.
>
>
> I'm rebuilding the kernel with this module, but I don't think this is my chip
> http://www.edimax.com/au/produce_detail.php?pd_id=399&pl1_id=1&pl2_id=44
>
> is it?
>

It should be, as it is the only Ralink chipset that supports 3x3
operation (i.e. 450 Mbps).
Also, the USB id of the device is listed in the driver under that
configuration option, so I'm pretty sure you
have to enable that configuration option ;-)

-- 
---
Gertjan
