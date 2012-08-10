Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40687 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759767Ab2HJXs5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 19:48:57 -0400
Message-ID: <50259DE2.4030209@hauke-m.de> (sfid-20120811_014939_431617_180F5C70)
Date: Sat, 11 Aug 2012 01:48:50 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Andy Gospodarek <andy@greyhouse.net>
CC: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Phil Perry <phil@elrepo.org>,
	lf driver backport
	<lf_driver_backport@lists.linux-foundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] compat: support RHEL6.3 as a build target
References: <2121451356.93690.1344518764022.JavaMail.root@neratec.com> <5025425A.2090207@hauke-m.de> <CAHashqAQ9tD3qmzMRNfzLcGbD2A9gykFjUbOhqZA=uLJBnQ4Gw@mail.gmail.com> <CAB=NE6VT+dxeN=BhWJrz+iS8GjS7o+phDJHRhuF2jRL_EEiGVA@mail.gmail.com> <CAHashqAGiBYAYNAGvDJw3-kurt1SZCFmpgqCnrLLux7Ek+oJYA@mail.gmail.com>
In-Reply-To: <CAHashqAGiBYAYNAGvDJw3-kurt1SZCFmpgqCnrLLux7Ek+oJYA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/10/2012 09:51 PM, Andy Gospodarek wrote:
> On Fri, Aug 10, 2012 at 3:50 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
>> On Fri, Aug 10, 2012 at 11:28 AM, Andy Gospodarek <andy@greyhouse.net> wrote:
>>> Did you try the patch I posted last night that has the updated define
>>> for no_printk()?  I saw the same error until I applied that patch.
>>
>> Andy, can you post a new patch on a new thread that is rebased on top
>> of the latest compat.git master and without putting stuff above the
>> patch ?
>>
>>   Luis
> 
> Yes I can.  You caught me at just the right time as my test build of
> compat-wireless-3.5-3 just finished.

I just tried "[PATCH] compat: fixup error in no_printk definition" and
now this error does not occur in my tests any more.

Thanks for the patch.

Hauke
