Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:57226 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbXINVBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 17:01:18 -0400
Received: by ug-out-1314.google.com with SMTP id z38so574263ugc
        for <linux-wireless@vger.kernel.org>; Fri, 14 Sep 2007 14:01:17 -0700 (PDT)
Message-ID: <46EAF698.8030604@gmail.com>
Date: Fri, 14 Sep 2007 22:01:12 +0100
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/05] orinoco: Agere/Lucent firmware download
References: <46E8557F.2080401@gmail.com> <1189746312.26312.39.camel@dv>	 <46EACAA5.2050706@gmail.com>  <46EAD760.9020102@gmail.com> <1189796807.3974.53.camel@johannes.berg>
In-Reply-To: <1189796807.3974.53.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2007-09-14 at 19:48 +0100, Dave wrote:
>> Either that was painless, or I did it wrong. Using sparse 3.0 the only
>> warnings were in orinoco.c, related to the use of ARRAY_SIZE. Errors
>> are false positives.
> 
> They're errors tho so sparse aborts and stops parsing the file at that
> point. A new git sparse can actually parse ARRAY_SIZE though, I can only
> recommend getting that.

Repeated with latest sparse from git. No warnings.

<snip>
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/irda/sir_dongle.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/hermes.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/hermes_dld.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco_cs.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco_plx.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco_pci.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco_tmd.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/orinoco_nortel.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/spectrum_cs.c
  CHECK   /usr/src/linux-current/linux-2.6/drivers/net/wireless/zd1201.c
<snip>

Regards,

Dave.
