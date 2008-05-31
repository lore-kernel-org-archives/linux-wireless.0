Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57465 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbYEaQmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2008 12:42:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Stefanik =?iso-8859-15?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: Wireless-testing's b43 panics in b43_generate_txhdr on packet transmit
Date: Sat, 31 May 2008 18:41:46 +0200
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
References: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com> <200805311711.16266.mb@bu3sch.de> <69e28c910805310934w7d2bc2ddkec27926a8c8033c4@mail.gmail.com>
In-Reply-To: <69e28c910805310934w7d2bc2ddkec27926a8c8033c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Message-Id: <200805311841.46740.mb@bu3sch.de> (sfid-20080531_184214_739549_F65D0AF7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 31 May 2008 18:34:29 Stefanik G=E1bor wrote:
> "BUG: unable to handle kernel NULL pointer dereference at 00000004
> IP: [<f8dd3a99>] :b43:b43_generate_txhdr+0x6a9/0x790

So can you put a few printks into the function to see where it derefere=
nces
a NULL pointer? (or use gdb to lookup the offset).


--=20
Greetings Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
