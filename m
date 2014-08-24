Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:59323 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbaHXKhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2014 06:37:32 -0400
Received: from pannekake.samfundet.no ([2001:67c:29f4::50] ident=unknown)
	by cassarossa.samfundet.no with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1XLVAu-0003bt-Mk
	for linux-wireless@vger.kernel.org; Sun, 24 Aug 2014 12:37:29 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1XLVAu-00010E-E6
	for linux-wireless@vger.kernel.org; Sun, 24 Aug 2014 12:37:28 +0200
Date: Sun, 24 Aug 2014 12:37:28 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Support Cisco DTPC IE to reduce transmit power
Message-ID: <20140824103728.GA2938@sesse.net> (sfid-20140824_123812_196637_F3B11F20)
References: <20140823212827.GB15466@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140823212827.GB15466@sesse.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 23, 2014 at 11:28:27PM +0200, Steinar H. Gunderson wrote:
> I noticed the other day that Linux and Cisco don't always seem to speak the
> same language when it comes to reducing the client transmit power. I've
> written a quick patch to try to remedy it; please consider applying to
> the wireless tree.

I looked in the CLI as well, and it pretty clearly indicates that the range
here is -127 to 127 dBm, which means I've changed my mind; this is not a
two-byte value. Updated patch attached.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
