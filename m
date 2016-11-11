Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53032 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966101AbcKKIvo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 03:51:44 -0500
Message-ID: <1478854301.6101.0.camel@sipsolutions.net> (sfid-20161111_095157_443691_8FE45F6C)
Subject: Re: =?UTF-8?Q?=E2=80=9CWireless?= usage of
 =?UTF-8?Q?pm-qos=E2=80=9D?=
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Aleksandersen <code@daniel.priv.no>,
        Linux kernel wireless <linux-wireless@vger.kernel.org>
Date: Fri, 11 Nov 2016 09:51:41 +0100
In-Reply-To: <1478814972.2686901.784042113.31AFDC88@webmail.messagingengine.com> (sfid-20161110_225617_763917_DA906456)
References: <1478814972.2686901.784042113.31AFDC88@webmail.messagingengine.com>
         (sfid-20161110_225617_763917_DA906456)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-11-10 at 22:56 +0100, Daniel Aleksandersen wrote:
> Hi,
> 
> This patch from Johannes Berg removed the /dev/network_latency
> system, right?
> http://marc.info/?l=linux-wireless&m=144483867919159&w=2

No, it didn't remove the system itself, just the use thereof in
wireless.

> So shouldn’t all the documentation be updated to indicate that it has
> been removed?
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/pm-qos
> https://wireless.wiki.kernel.org/en/developers/documentation/ieee8021
> 1/power-savings

Right, those should probably be removed.

> https://www.kernel.org/doc/Documentation/power/pm_qos_interface.txt

This still exists, even if it may have no users now - haven't checked.

johannes
