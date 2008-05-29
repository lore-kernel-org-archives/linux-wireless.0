Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:24990 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbYE2SxI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 14:53:08 -0400
Subject: Re: ath5k can't connect on 5424
From: Pavel Roskin <proski@gnu.org>
To: "Jerry Quinn (ibm)" <jlquinn@optonline.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	mickflemm@gmail.com
In-Reply-To: <483EC752.1040609@optonline.net>
References: <4838A467.1000700@optonline.net>
	 <20080528002814.GF7779@tuxdriver.com>  <483EC752.1040609@optonline.net>
Content-Type: text/plain
Date: Thu, 29 May 2008 14:52:59 -0400
Message-Id: <1212087179.3808.2.camel@dv> (sfid-20080529_205313_045023_5ADDFDA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-05-29 at 11:10 -0400, Jerry Quinn (ibm) wrote:

> Mike, thanks for pointing me to the updated ath_info.
> 
> Here's the dump from my chip:
> 
> naga:~/ath_info# ./ath_info -v 0xedf00000
> #DBG main: sleep_ctl reg 00000000   reset_ctl reg 00000000
>  -==Device Information==-
> MAC Version:  2424  (0xa0)
> MAC Revision: 5424  (0xa3)
> Warning: Invalid EEPROM Magic number!

If I understand correctly, it means that your device uses a new EEPROM
layout that hasn't been reverse engineered yet.  Most of the remaining
data cannot be trusted.  It's not surprising that your device is not
working with ath5k.

-- 
Regards,
Pavel Roskin
