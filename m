Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16743 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab1CQBMm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 21:12:42 -0400
Message-ID: <20110316210247.6p9x1s7a8k0ss4wc-cebfxv@webmail.spamcop.net>
Date: Wed, 16 Mar 2011 21:02:47 -0400
From: Pavel Roskin <proski@gnu.org>
To: Dave Kilroy <kilroyd@googlemail.com>
Cc: Joe Gunn <armadefuego@yahoo.com>,
	orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [Orinoco-devel] [PATCH 2.6.38-rc8-wl 1/1] orinoco: Reduce lock
	contention by reporting static errors before locking
References: <297417.86150.qm@web57403.mail.re1.yahoo.com>
	<4D8156F9.8020609@gmail.com>
In-Reply-To: <4D8156F9.8020609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

>> +		return(-EOPNOTSUPP);

"return" is not a function to be written like that.  Please use the  
existing coding style used in the kernel.  Also please use  
checkpatch.pl to catch style violations.

-- 
Regards,
Pavel Roskin
