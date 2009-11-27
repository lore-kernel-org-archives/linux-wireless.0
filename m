Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23108.mail.ird.yahoo.com ([217.146.189.48]:42487 "HELO
	web23108.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751529AbZK0Mds convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 07:33:48 -0500
Message-ID: <800253.584.qm@web23108.mail.ird.yahoo.com>
Date: Fri, 27 Nov 2009 04:33:53 -0800 (PST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: RTL8187 warnings on suspend
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200911270945.31125.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



--- On Fri, 27/11/09, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

> 
> _stop will always be called first in suspend, mac80211
> calls everything in
> right order. The problem here is that in suspend the device
> is disconnected
> (probably because we don't have any reset/resume support),

Hmm, that reminds me - I thought hibernate (suspend to disk) works, but suspend to ram doesn't? That's why I have unload on suspend configured - that used to work on fedora 11 until I upgraded to fedora 12 a few days ago (my machine now crashes on resume but presumably unrelated).

Maybe we should re-visit the issue of adding suspend()/resume() ?



      
