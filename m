Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64025 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab0LPUcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 15:32:15 -0500
Received: by wwa36 with SMTP id 36so2858865wwa.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 12:32:14 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 16 Dec 2010 12:32:14 -0800
Message-ID: <AANLkTi=fPHdnizvPsDVQU+aMcYmMzdu6thNvXG2YLMuX@mail.gmail.com>
Subject: Help with Libertas error
From: Matt Rosenthal <matt@touchrev.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
If possible can someone help point me in the right direction.  I am
building an embedded android device.  I am currently using the froyo
code base on the 2.6.32 Linux kernel.
My system works well but under some heave wifi loads the wifi stops
working.  I am using the Marvell 8686 wifi chip connected to a TI
OMAP3 processor.

The way to create the problem is to download large files over wifi or
continuously stream data over wifi.

Below is an error message I see on the console.
---------------------------------------------------------------------
libertas: Excessive timeouts submitting command 0x000b
libertas: PREP_CMD: command 0x000b failed: -110
libertas: PREP_CMD: command 0x000b failed: -110
libertas: requeueing command 0x000b due to timeout (#1)
libertas: command 0x000b timed out
libertas: requeueing command 0x000b due to timeout (#2)
libertas: command 0x000b timed out
libertas: requeueing command 0x000b due to timeout (#3)
libertas: command 0x000b timed out
libertas: Excessive timeouts submitting command 0x000b
libertas: PREP_CMD: command 0x000b failed: -110
libertas: command 0x000b timed out
libertas: requeueing command 0x000b due to timeout (#1)
libertas: command 0x000b timed out
libertas: requeueing command 0x000b due to timeout (#2)
libertas: command 0x000b timed out
libertas: requeueing command 0x000b due to timeout (#3)
libertas: command 0x000b timed out
libertas: Excessive timeouts submitting command 0x000b
libertas: PREP_CMD: command 0x000b failed: -110
libertas: command 0x000b timed out
libertas: requeueing command 0x000b due to timeout (#1)
libertas: command 0x000b timed out
libertas: requeueing command 0x000b due to timeout (#2)
libertas: command 0x000b timed out
libertas: requeueing command 0x000b due to timeout (#3)
------------------------------------------------------------------------

After this error message shows up the wifi no longer functions at all.
 Any help is much appreciated.
Thanks

Matt

-- 
Matthew Rosenthal
TPK USA, LLC
Touch Revolution BU

Confidentiality Disclaimer: This e-mail message and any attachments
are private communication sent by TPK USA LLC, and may contain
confidential, legally privileged information meant solely for the
intended recipient. If you are not the intended recipient, you are
hereby notified that any use, dissemination, distribution or copying
of this communication is strictly prohibited. Please notify the sender
immediately by replying to this message, then delete the e-mail and
any attachments from your system. Thank you.
