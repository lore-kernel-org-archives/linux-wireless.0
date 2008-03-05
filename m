Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45330 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYCEOSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 09:18:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Ahmed Ammar" <b33fc0d3@gmail.com>
Subject: Re: B43 will not associate
Date: Wed, 5 Mar 2008 15:17:31 +0100
Cc: linux-wireless@vger.kernel.org
References: <84ac67910803041143y76e378c7m2fd88a26115f0ae2@mail.gmail.com> <200803042047.35710.mb@bu3sch.de> <84ac67910803041413s510c5513k25f77762b0e70d@mail.gmail.com>
In-Reply-To: <84ac67910803041413s510c5513k25f77762b0e70d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803051517.31919.mb@bu3sch.de> (sfid-20080305_141806_977767_4D5716E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 March 2008 23:13:38 Ahmed Ammar wrote:
> > You are wrong:
> 
> I am NOT wrong. wlan0 is a rt61pci device.

Ok, gonna add you to my blacklist.

It's impossible to debug something, if you don't fscking
tell me your testbed setup and what's going on/wrong.
Your threads are a complete waste of time.

So if somebody else, who is capable to write usable bugreports,
does seem a similiar issue, please open a new thread and CC me.

Of course I want to fix this bug, but that doesn't work without
the help of the reporter. And no, throwing mail-forwards and
bugreports at me that consist of
<quote>
> b43 driver will never associate to my AP. below is the full dmesg
> output. Also attached is the wireless capture from another card.
</quote>
,a dmesg log and a capture are simply not the way bugreporting works.
This is useless.

-- 
Greetings Michael.
