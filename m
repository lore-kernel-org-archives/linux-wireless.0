Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36868 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZHJTML convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 15:12:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH RFC] ssb: Implement the remaining rev.8 SPROM vars needed  for LP-PHY
Date: Mon, 10 Aug 2009 21:12:09 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A806B9E.5010105@gmail.com> <200908102101.38698.mb@bu3sch.de> <69e28c910908101207p17139562v55ede047c944dae@mail.gmail.com>
In-Reply-To: <69e28c910908101207p17139562v55ede047c944dae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908102112.09368.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 August 2009 21:07:45 Gábor Stefanik wrote:
> > Also, it seems you need +1 instead of +2 (it is an u16 pointer).
> I'm adding to _offset, not to SPOFF(_offset). AFAICS _offset is not an
> u16 pointer, it's a plain #defined number, unlike SPOFF(_offset).

Ah ok. All those parenthesis are a little bit confusing. 8-X

-- 
Greetings, Michael.
