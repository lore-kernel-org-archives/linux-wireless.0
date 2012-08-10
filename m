Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38534 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab2HJTvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 15:51:54 -0400
Received: by wibhr14 with SMTP id hr14so1659135wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 12:51:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VT+dxeN=BhWJrz+iS8GjS7o+phDJHRhuF2jRL_EEiGVA@mail.gmail.com>
References: <2121451356.93690.1344518764022.JavaMail.root@neratec.com>
	<5025425A.2090207@hauke-m.de>
	<CAHashqAQ9tD3qmzMRNfzLcGbD2A9gykFjUbOhqZA=uLJBnQ4Gw@mail.gmail.com>
	<CAB=NE6VT+dxeN=BhWJrz+iS8GjS7o+phDJHRhuF2jRL_EEiGVA@mail.gmail.com>
Date: Fri, 10 Aug 2012 15:51:53 -0400
Message-ID: <CAHashqAGiBYAYNAGvDJw3-kurt1SZCFmpgqCnrLLux7Ek+oJYA@mail.gmail.com> (sfid-20120810_215158_000032_A9868180)
Subject: Re: [PATCH v2] compat: support RHEL6.3 as a build target
From: Andy Gospodarek <andy@greyhouse.net>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Phil Perry <phil@elrepo.org>,
	lf driver backport
	<lf_driver_backport@lists.linux-foundation.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 10, 2012 at 3:50 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Fri, Aug 10, 2012 at 11:28 AM, Andy Gospodarek <andy@greyhouse.net> wrote:
>> Did you try the patch I posted last night that has the updated define
>> for no_printk()?  I saw the same error until I applied that patch.
>
> Andy, can you post a new patch on a new thread that is rebased on top
> of the latest compat.git master and without putting stuff above the
> patch ?
>
>   Luis

Yes I can.  You caught me at just the right time as my test build of
compat-wireless-3.5-3 just finished.
