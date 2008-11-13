Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:63177 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYKMUDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 15:03:01 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1043551rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 12:03:00 -0800 (PST)
Reply-To: <IskiMJ@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: hostap managed mode, blank ESSID
Date: Thu, 13 Nov 2008 13:02:49 -0700
Message-ID: <NGBBIAECGKIICNHKJGIPCEIPCIAA.IskiMJ@gmail.com> (sfid-20081113_210307_423997_A01562B7)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
From: iskimj@gmail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm running Ubuntu with kernel 2.6.27-7. I am trying to set up a
Prism/Intersil PCMCIA card (Microsoft MN-520) with firmware version 1.4.9.

I am able to the orinoco module but I get many errors. I asked in that
mailing list and one suggestion was to try the hostap module. I am trying to
set up hostap but need a bit of help.

It is my understanding that I need to operate it in "managed" mode to
connect as a client to a wireless AP. I can set the managed mode but I can't
seem to set the ESSID, iwconfig will report EASED: " ". If I then change to
"master" mode it reports the correct ESSID. Are there some additional steps
that I need to do? Is there a bug in the driver?

Thanks,
Greg

