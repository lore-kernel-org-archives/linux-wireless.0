Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34219 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbZFBPRF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 11:17:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: b43 vs b43legacy
Date: Tue, 2 Jun 2009 17:17:01 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <loom.20090529T190620-42@post.gmane.org> <4A20505D.40908@lwfinger.net> <4A244C5A.50307@free.fr>
In-Reply-To: <4A244C5A.50307@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200906021717.01320.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 01 June 2009 23:47:06 matthieu castet wrote:
> Ok but what prevent b43 to support core 4 chip with v4 firmware like the 
> broadcom driver does ?
> I am aware that the current driver doesn't support it, but what are the 
> missing part to support it ?

Recent broadcom drivers do not support <=rev4 anymore.
There are lots of differences between those devices and devices >=rev5.
So we chose to fork it.
That's it. It's as simple as that. Why does it surprise you that much? Lots
of other devices require a separate driver for legacy devices, too.

-- 
Greetings, Michael.
