Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34155 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbbGAXGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 19:06:09 -0400
Received: by lagx9 with SMTP id x9so50110521lag.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2015 16:06:08 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 1 Jul 2015 16:06:07 -0700
Message-ID: <CAPA_7haE3gvZm2suZ+duDs6MhaOdc1JwQ4n6qyu4DY+KevXAZA@mail.gmail.com> (sfid-20150702_010620_893703_7E6C5CDC)
Subject: rt2800usb Dual Mode
From: Stark Pister <stark@cirrent.co>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a panda wireless module that uses the rt2800usb driver and I am
trying to ascertain if it is capable of using both station and ap
modes at the same time. The "valid interface combinations" section of
"iw phy phy0 info" lists the following:

* #{ AP, mesh point } <= 8,
  total <= 8, #channels <= 1

I have been told that to use both station and ap mode, I also need a
#{ managed } <= 1 in that section. However, the wifi module clearly
knows how to operate a managed station interface (that is the default
behavior I believe). Is this just a mislabeling of valid interface
combinations or does the #{ managed } tag mean something other than it
being able to have a managed station?

If it is possible to use this chip to operate in both modes
simultaneously, how would I go about doing that. I assume I would use
two virtual interfaces on top of the phy0 interface, but the
linux-wireless page for virtual interfaces is empty for both the
station and ap sections of the doc.
(https://wireless.wiki.kernel.org/en/users/documentation/iw/vif)
I can infer the commands I would use to set up those interfaces but
that same doc also says "(special steps required)" about the mode
"AP".

Any help would be really appreciated. Feel free to point me to
documentation if I have missed something.

-- 
Stark Pister
Software Developer
Cirrent.co
(925) 818-1813
