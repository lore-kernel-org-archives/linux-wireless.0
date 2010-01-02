Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:38939 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab0ABHtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 02:49:08 -0500
Received: by ewy19 with SMTP id 19so5747672ewy.21
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jan 2010 23:49:07 -0800 (PST)
To: Carl =?iso-8859-15?Q?F=FCrstenberg?= <azatoth@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: libnl, bug question, and lib query
References: <91f186a81001011507h48c1b887u323fe43dd4c8fdb1@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 02 Jan 2010 09:49:03 +0200
In-Reply-To: <91f186a81001011507h48c1b887u323fe43dd4c8fdb1@mail.gmail.com>
 ("Carl =?iso-8859-15?Q?F=FCrstenberg=22's?= message of "Sat\, 2 Jan 2010
 00\:07\:03 +0100")
Message-ID: <878wchvte8.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Carl Fürstenberg <azatoth@gmail.com> writes:

> I'll start this up with three different question, hope that's not a
> problem instead of sending three different mails.
>
> First I wonder if I should, in a production environment using the
> nl80211, stick to use libnl 1.* or should I use use the git 2.0?

I have heard that libnl 2.0 does not have stable API currently. So
it's better to avoid it.

-- 
Kalle Valo
