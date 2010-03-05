Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52532 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434Ab0CEIzL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 03:55:11 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1NnTJJ-0001LF-Ao
	for linux-wireless@vger.kernel.org; Fri, 05 Mar 2010 09:55:05 +0100
Received: from c-71-195-11-126.hsd1.mn.comcast.net ([71.195.11.126])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 05 Mar 2010 09:55:05 +0100
Received: from nickbertrand by c-71-195-11-126.hsd1.mn.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 05 Mar 2010 09:55:05 +0100
To: linux-wireless@vger.kernel.org
From: Nick Bertrand <nickbertrand@comcast.net>
Subject: Re: =?utf-8?b?S0VZX1JGS0lMTA==?= not found on kernel 2.6.30
Date: Fri, 5 Mar 2010 05:24:33 +0000 (UTC)
Message-ID: <loom.20100305T062225-730@post.gmane.org>
References: <e44ae5e1003032058g2cf1b5a1lcf62e8919dddea58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I ran into the same problem but was able to get around it by patching
include/linux/input.h. Details here: http://patchwork.kernel.org/patch/46630/

HTH,

Nick Bertrand

