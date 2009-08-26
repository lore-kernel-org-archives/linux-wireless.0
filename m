Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39102 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbZHZWiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 18:38:05 -0400
Received: by ewy2 with SMTP id 2so666549ewy.17
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 15:38:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A95AA64.20502@gmail.com>
References: <4a5cf0b4.F1C7R/E9sD5tpPd2%Larry.Finger@lwfinger.net>
	 <4A94B01E.9040309@gmail.com> <4A94C3E9.6070409@lwfinger.net>
	 <4A95AA64.20502@gmail.com>
Date: Wed, 26 Aug 2009 23:38:06 +0100
Message-ID: <3ace41890908261538s6818b56ax56cca5af18398dbc@mail.gmail.com>
Subject: Re: [PATCH] rtl8187: Fix for kernel oops when unloading with LEDs
	enabled
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Richard Farina <sidhayn@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2009 at 10:34 PM, Richard Farina<sidhayn@gmail.com> wrote:

> I apologize if you thought there was an accusation here, that certainly was
> not my intention. With all due respect assuming that I'm
> a jerk is neither safe nor polite.  In your original patch for this I find
> the following text:

> Yes, I realize that, which is why I said the "bug is still alive" not "the
> patch is not applied".  I even went out of my way to describe how the
> testing was different...

While I thought Larry's reply was a bit brief, I looked back on the
thread and I think I am on Larry's side. All you mentioned was that
you had a crash on unplug, and then you automatically assume that it
is because the most recent crash-related fix (which Larry kindly made)
did not work. You have no proof that your problem is even the same as
what the fix tried to solve. You did not try to go back to a non-LED
enabled compat-wireless, for example.

To be honest, I think you 'went out of your way' to try to pin your
problem on one of the developers, so that your problem is guaranteed
to receive attention. That's not very fair...

That said, I think this thread has gone on long enough - all that
happened is that (1) you had a crash on unplug, (2) you tried to pin
it on Larry, (3) many people has checked and verified that what Larry
did went in, (4) we still don't know whether your crash is related to
the LED change or not.

Since we still don't know whether your crash is related to any
LED-related change or not, this thread is not going well.
