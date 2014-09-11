Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35826 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbaIKKPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:15:20 -0400
Received: by mail-ie0-f179.google.com with SMTP id rl12so7493537iec.24
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2014 03:15:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54106BB0.1090105@maya.org>
References: <540FA8D9.2070803@netcommwireless.com>
	<54100F0E.8030204@broadcom.com>
	<CAGXE3d9FRLOPQ1pO6WFWy4FF67PGbo5ztfhLELydq3k410731w@mail.gmail.com>
	<54106BB0.1090105@maya.org>
Date: Thu, 11 Sep 2014 12:15:19 +0200
Message-ID: <CAGXE3d-thQqqcvOTHYfuWEvi+baeGAuX79_-Uvw9xT73to=K5g@mail.gmail.com> (sfid-20140911_121524_123364_FD51918F)
Subject: Re: Not reaching optimum speeds with IEEE 802.11n
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: Arend van Spriel <arend@broadcom.com>,
	Sourav <sourav.chakraborty@netcommwireless.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 10, 2014 at 5:18 PM, Andreas Hartmann
<andihartmann@freenet.de> wrote:
> Hello Helmut!
>
> Helmut Schaa wrote:
>> On Wed, Sep 10, 2014 at 10:42 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>> On 09/10/14 03:26, Sourav wrote:
>>>> We are using Ralink chip Rt3072L (using rt2800usb drivers rt2800usb.c),
>>
>> The Ralink USB hardware is quite bad in reporting TX status and as
>> such minstrel_ht cannot do proper rate selection.
>
> Rate control of the vendor driver seems to work just fine (or at least
> better as minstrel_ht).

Indeed, the ralink proprietary rate control does not depend on per
frame statistics.

>
> Iow: minstrel_ht doesn't meet the requirements of ralink chipsets :-).

Yep.

> But this is not the only problem of rt2800usb. As long as a driver has
> the ability to damage a device [1], there is something more basically
> broken!

Also agreed.

Helmut
