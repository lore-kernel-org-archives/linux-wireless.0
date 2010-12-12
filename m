Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f170.google.com ([209.85.214.170]:52382 "EHLO
	mail-iw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab0LLRFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 12:05:08 -0500
Received: by iwn6 with SMTP id 6so7979757iwn.1
        for <linux-wireless@vger.kernel.org>; Sun, 12 Dec 2010 09:05:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20101212T110657-413@post.gmane.org>
References: <loom.20101212T101545-636@post.gmane.org>
	<loom.20101212T110657-413@post.gmane.org>
Date: Sun, 12 Dec 2010 18:05:06 +0100
Message-ID: <AANLkTimiNLZ8EFPEwbKW3UA7FMSxmJOV-B9pWY4h9c34@mail.gmail.com>
Subject: Re: carl9170 802.11n-AP
From: Christian Lamparter <chunkeey@googlemail.com>
To: thomas <messier31@gmx.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 12, 2010 at 11:14 AM, thomas <messier31@gmx.net> wrote:
> I just saw that there could be "aggregation stalls" with "any Intel N Wifi
> Link".
> I am using Intel Wifi Link 5100 and the driver frequently restarts under
> heavy load.

see Intel's bugzilla, lots of angry posts there:
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2214#c19 (etc...)

I am ill, so you'll have to do the research on iwlwifi vs. carl9170 on your own,
but it's all there just take a look at the original vendor
driver(otus)+firmware(ar9170fw).

Regards,
   Chr
