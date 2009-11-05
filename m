Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34143 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbZKETY6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 14:24:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: [PATCH] rtl8187: Remove deprecated 'qual' from returned RX status
Date: Thu, 5 Nov 2009 20:24:30 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
References: <4af26c2f.v0dYcKOlddHI9QEQ%Larry.Finger@lwfinger.net> <3ace41890911051121u16c7de8cpb97d0be12cdd0aa6@mail.gmail.com>
In-Reply-To: <3ace41890911051121u16c7de8cpb97d0be12cdd0aa6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911052024.32608.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 November 2009 20:21:39 Hin-Tak Leung wrote:
> > +                * is derived from the AGC. The arbitrary scaling constants
> >                 * are chosen to make the results close to the values obtained
> >                 * for a BCM4312 using b43 as the driver. The noise is ignored

It's not really a good idea to take b43 for reference, because the values/scales
are chosen pretty arbitrarily in that driver. So you basically end up
with an arbitrary^2 value.

-- 
Greetings, Michael.
