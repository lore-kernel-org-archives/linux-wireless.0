Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:60688 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbXJHVF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 17:05:29 -0400
Received: by ug-out-1314.google.com with SMTP id z38so1930ugc
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2007 14:05:27 -0700 (PDT)
To: Dan Williams <dcbw@redhat.com>
Subject: Re: rfkill framework status?
Date: Mon, 8 Oct 2007 23:21:41 +0200
Cc: linux-wireless@vger.kernel.org
References: <1191851349.2703.34.camel@localhost.localdomain>
In-Reply-To: <1191851349.2703.34.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710082321.41169.IvDoorn@gmail.com> (sfid-20071008_220532_398308_EB62795B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I know there's a bunch of stuff queued for 2.6.24.  What's the general
> status of the rfkill stuff, and are there any drivers using it already
> besides b43 and rt2x00? 

As far as I know rfkill is working correcyly now. Michael has added
some patches to made rfkill usefull for devices that toggle the radio
state in hardware but still want to send the event to userspace/other devices.

However I have no idea what drivers support rfkill at this moment,
or which drivers are investigating the rfkill possibilities for their driver.

> This is something I'd like to get HAL 
> supporting pretty quickly after 2.6.24 opens up if just to get a
> jump-start on the situation.  Any pointers to userland interaction or
> are people better off just reading the code?

Well one of the patches pending for 2.6.24 is the documentation file
about the userspace interface. It isn't much yet, but if you have any
additions you feel that should be added, based on your work for getting
HAL support, feel free to either mail me the suggestions or post a patch
that updates the documentation file. :)

Ivo
