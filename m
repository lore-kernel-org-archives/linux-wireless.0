Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:36202 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbZHUMrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 08:47:01 -0400
Received: by ewy3 with SMTP id 3so606264ewy.18
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 05:47:01 -0700 (PDT)
From: Miguel Garcia-Lopez <mgarcia@envitel.com>
To: Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1250858377.5137.1.camel@johannes.local>
Subject: Re: USB wireless support for ARM device and old kernel version
References: <55FEAD01-712B-4165-9F4D-260BDC3CA14A@envitel.com> <1250858377.5137.1.camel@johannes.local>
Message-Id: <7DD47494-1519-46AC-A28B-3ED736B4305A@envitel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v936)
Date: Fri, 21 Aug 2009 14:46:17 +0200
Cc: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 21/08/2009, at 14:39, Johannes Berg wrote:

> There are none. 2.6.10 basically has no wireless drivers. You can  
> try to
> backport compat-wireless, but you're on your own. Just upgrade your
> kernel to 2.6.27 or later.


Thanks so much for the concise and quick response. We will try to find  
out wether the kernel upgrade is possible for our board.

Regards and thanks again!

--
Miguel García López
Director Técnico
Technical Manager
.......................................................
E N V I T E L
Parque Científico de Madrid - Local 105
PTM - C/Santiago Grisolía, 2
28760 Tres Cantos - Madrid - Spain
T: +34 91 334 06 56
F: +34 91 358 52 36
M: +34 649 91 60 60
.......................................
mgarcia@envitel.com
www.envitel.com





