Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:39545 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbaIJPU4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 11:20:56 -0400
Message-ID: <54106BB0.1090105@maya.org> (sfid-20140910_172101_703756_E36F9E32)
Date: Wed, 10 Sep 2014 17:18:08 +0200
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	Arend van Spriel <arend@broadcom.com>
CC: Sourav <sourav.chakraborty@netcommwireless.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Not reaching optimum speeds with IEEE 802.11n
References: <540FA8D9.2070803@netcommwireless.com>	<54100F0E.8030204@broadcom.com> <CAGXE3d9FRLOPQ1pO6WFWy4FF67PGbo5ztfhLELydq3k410731w@mail.gmail.com>
In-Reply-To: <CAGXE3d9FRLOPQ1pO6WFWy4FF67PGbo5ztfhLELydq3k410731w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Helmut!

Helmut Schaa wrote:
> On Wed, Sep 10, 2014 at 10:42 AM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 09/10/14 03:26, Sourav wrote:
>>> We are using Ralink chip Rt3072L (using rt2800usb drivers rt2800usb.c),
> 
> The Ralink USB hardware is quite bad in reporting TX status and as
> such minstrel_ht cannot do proper rate selection.

Rate control of the vendor driver seems to work just fine (or at least
better as minstrel_ht).

Iow: minstrel_ht doesn't meet the requirements of ralink chipsets :-).

But this is not the only problem of rt2800usb. As long as a driver has
the ability to damage a device [1], there is something more basically
broken!


[1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/126856


Regards,
Andreas
