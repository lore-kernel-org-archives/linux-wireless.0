Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49132 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab0FMUtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jun 2010 16:49:49 -0400
Received: by wyb40 with SMTP id 40so3163190wyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jun 2010 13:49:48 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 13 Jun 2010 17:49:47 -0300
Message-ID: <AANLkTim4kDJZnEdNy-C4xhOigWiTWQZhVJAs36LOUbjQ@mail.gmail.com>
Subject: wireless button problem with atheros on hp machines
From: Leonardo <sombriks@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello all, i don't know if this is the correct channel to report, but
from Slackware 13.0 (2.6.29.6) to 13.1 (2.6.33.4) the wireless button
stopped to work properly.

it is happening on 2 different hp machines: hp dv5-1220br (AR5001) and
hp dv4-2140us (AR9285).

basically i can't touch the wireless button, if i do that i will not
be able to recover the net, also the button color will not back to
blue, will remain orange.

also if i touch the button not even restarting the machine or removing
the battery the bluetooth subsystem come back.

on dv5 i have only linux, but on dv4 if i give up and enter on windows
just to restart bluetooth;

as i related before, at least on dv5 one it worked like a charm on older one.

please if anyone can help, tell me what can i do to help to track such
bug (what kind of output to send, maybe a downgrade, etc)

thanks in advance.
