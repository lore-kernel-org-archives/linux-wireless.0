Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41794 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbZHCVQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 17:16:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH RESEND] b43: implement baseband init for LP-PHY <= rev1
Date: Mon, 3 Aug 2009 23:16:30 +0200
Cc: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A7610AE.5000908@gmail.com> <69e28c910908031341n439384b4ned41f2983ab1de29@mail.gmail.com> <4A774F76.6020207@lwfinger.net>
In-Reply-To: <4A774F76.6020207@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908032316.30237.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 03 August 2009 22:58:30 Larry Finger wrote:
> Gábor states it the way the Broadcom routine is written. They have the
> flags divided into 3 16-bit values - high, middle, and low. The values
> are kept in arrays - one set is for the current band and the other is
> for both bands. When the routine is entered, the appropriate quantity
> is saved in a temporary, then the array value is maskset. Only when
> the resulting value changes is the shared memory location updated. The
> implication is that shared memory writes are expensive. Is that true?

No. I think it has other reasons.

-- 
Greetings, Michael.
