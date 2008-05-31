Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:37109 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbYEaR7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2008 13:59:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: Wireless-testing's b43 panics in b43_generate_txhdr on packet transmit
Date: Sat, 31 May 2008 19:59:18 +0200
Cc: Pavel Roskin <proski@gnu.org>,
	Stefanik =?iso-8859-1?q?G=E1bor?= <netrolller.3d@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
References: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com> <1212252522.2766.8.camel@rd>
In-Reply-To: <1212252522.2766.8.camel@rd>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805311959.18475.mb@bu3sch.de> (sfid-20080531_195945_336624_60A24949)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 31 May 2008 18:48:42 Pavel Roskin wrote:
> It's strange that other drivers (b43legacy, ath5k) use

b43legacy does not support hwcrypto, so it can't crash.

-- 
Greetings Michael.
