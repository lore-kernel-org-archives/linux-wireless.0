Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:54208 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaIKNQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 09:16:01 -0400
Received: by mail-qc0-f169.google.com with SMTP id r5so2060460qcx.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2014 06:15:59 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Sep 2014 18:45:58 +0530
Message-ID: <CABH6M7J1JaKxOfQmC0+hSSBYU+3nBVKKC91TwYixFJyBfDy79g@mail.gmail.com> (sfid-20140911_151614_272497_D7A6D2B9)
Subject: Mesh support on iwlwifi driver
From: Ashish Gupta <ashmew2@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I am trying to run a mesh using open80211s (which is now a part of the
linux kernel) but if I list the capabilities of my card(driver) using iw
list, I get this (only relevant part):

Supported interface modes:
         * IBSS
         * managed
         * AP
         * AP/VLAN
         * monitor

"Mesh" is missing from this list, but having it here is crucial for
running the mesh, which otherwise errors with out an "Unsupported
operation error" when trying to set the network card to Mesh mode.

I would be grateful if you could point me to the right direction for
getting mesh support onto iwlwifi. I'm willing to write a patch for this
driver.

The only relevant discussion I have found about this is :
http://permalink.gmane.org/gmane.linux.kernel.wireless.general/52880

But it seems an old thread and maybe things have changed over time.

Also, there seems to be a patch that someone wrote :
http://markmail.org/thread/jzm672fnv7zy7u6p

I am not sure about the status of that patch.

I really want to get the mesh running on my Intel Centrino N 1030 network
card at the earliest. I have done some reading up on developing network
drivers and also have the latest source code of the linux kernel tree for
looking at driver sources.

http://wireless.kernel.org/en/users/Drivers/iwlwifi is the most complete
guide I have found on the subject, but it does not seem to talk about mesh
much.

What can I do to get mesh support onto iwlwifi?

Thanks a lot.

Regards,
Ashish Gupta
