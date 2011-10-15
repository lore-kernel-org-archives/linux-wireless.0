Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:14255 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1JOVWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 17:22:05 -0400
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id p9FLM3np031502
	for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 14:22:03 -0700
Received: from pzk4 (pzk4.prod.google.com [10.243.19.132])
	by wpaz21.hot.corp.google.com with ESMTP id p9FLM1OF015255
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 14:22:02 -0700
Received: by pzk4 with SMTP id 4so3553079pzk.10
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 14:22:01 -0700 (PDT)
Date: Sat, 15 Oct 2011 14:21:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
cc: werner <w.landgraf@ru.ru>, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: 3.1.0-rc9+ : wlan stops working w/o any error messages
In-Reply-To: <201110152119.58509.toralf.foerster@gmx.de>
Message-ID: <alpine.DEB.2.00.1110151416360.15894@chino.kir.corp.google.com> (sfid-20111015_232305_783785_3F1E403A)
References: <201110152119.58509.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-252661854-1318713541=:15894"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-252661854-1318713541=:15894
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1110151419091.15894@chino.kir.corp.google.com>

On Sat, 15 Oct 2011, Toralf Förster wrote:

> With a ThinkPad T400 with "Intel Corporation PRO/Wireless 5100 AGN [Shiloh] 
> Network Connection" I experienced few times in the last week that the suddenly 
> the network stops to work - no messages in /var/log/messages nor any other 
> outout. Only  a restart of the network services helped
> 
> n22 ~ # uname -a
> Linux n22 3.1.0-rc9+ #1 SMP Fri Oct 14 19:21:56 CEST 2011 i686 Intel(R) 
> Core(TM)2 Duo CPU P8600 @ 2.40GHz GenuineIntel GNU/Linux
> 
> It is an almost stable Gentoo.
> 
> Anybody else made similar experiences ?
> 

It looks like werner is reporting a similar problem in 
https://lkml.org/lkml/2011/10/15/67 but with a different laptop, 
information is vague in that regression report.

Adding him, Wey-Yi Guy from Intel, and linux-wireless mailing list to the 
cc.

What's the last kernel prior to 3.1-rc9 that worked for you?

What does "iwconfig" show?

What does "dmesg | grep iwlagn" show?
--397155492-252661854-1318713541=:15894--
