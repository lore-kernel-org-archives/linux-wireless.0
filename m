Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:52616 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbXHDLRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Aug 2007 07:17:40 -0400
Received: by ug-out-1314.google.com with SMTP id j3so533614ugf
        for <linux-wireless@vger.kernel.org>; Sat, 04 Aug 2007 04:17:38 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: further plan wrt. monitor interfaces
Date: Sat, 4 Aug 2007 13:22:14 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1186178959.13315.30.camel@johannes.berg>
In-Reply-To: <1186178959.13315.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708041322.14876.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>  * FIF_PROMISC_IN_BSS	(BSS filters still on, but otherwise promisc)
>  * FIF_ALLMULTI		(all multicast frames are allowed through)
>  * FIF_BROADCAST	(broadcast frames are allowed through)
>  * FIF_FCSFAIL		(frames with bad FCS are allowed through)
>  * FIF_PLCPFAIL		(frames with bad PLCP checksum are allowed through)
>  * FIF_CONTROL		(control frames are shown)
>  * FIF_OTHER_BSS	(frames from other BSSes are shown, subject to the
> 			 other filters)
> [missing anything?]

rt2x00 registers have the 2 following entries as well:

	Physical error
	Version error


The rest of the idea looks pretty good, si I will be happy to implement it for rt2x00. :)

Ivo


