Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:35353 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbZDAUzb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 16:55:31 -0400
Received: by an-out-0708.google.com with SMTP id d14so190072and.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Apr 2009 13:55:29 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 1 Apr 2009 16:55:29 -0400
Message-ID: <86201b3f0904011355p788ee867p300b5be24569e46b@mail.gmail.com> (sfid-20090401_225534_289155_7CA4C47F)
Subject: Fragmentation
From: Charles Gordon <digigordo@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm working on a driver which will use mac80211.  My hardware cannot
transmit a frame larger than 1792 bytes, or receive frames larger than
2048 bytes.  Right now I am relying on the fragmentation routines
built into mac80211.  Is there a way for my driver to tell mac80211
what the maximum transmit and receive frame sizes are?  Do I need to
implement my own fragmentation code to handle this?

Thanks for you help.
