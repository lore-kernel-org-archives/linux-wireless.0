Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f190.google.com ([209.85.216.190]:44367 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbZGBNRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 09:17:51 -0400
Received: by pxi28 with SMTP id 28so1528589pxi.33
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2009 06:17:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ec2083b20906171932g401fab8fk15531459e1dc4d41@mail.gmail.com>
References: <ec2083b20906120654j370e5bdo724a7c3b6d505a6c@mail.gmail.com>
	 <4A326771.6030301@lwfinger.net>
	 <ec2083b20906120759x4a8c247eh61d1f6bdb6f194f6@mail.gmail.com>
	 <20090618021017.19879.qmail@stuge.se>
	 <ec2083b20906171932g401fab8fk15531459e1dc4d41@mail.gmail.com>
Date: Thu, 2 Jul 2009 08:17:54 -0500
Message-ID: <ec2083b20907020617q689f9672h383bb853ba6019d0@mail.gmail.com>
Subject: Re: 4311 not detected at all
From: "Fabio A. Correa" <facorread@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All,

I recompiled the Linux kernel with ssb, phy and b43 as modules. I made
sure those modules were loaded after login, and now the b43 driver
properly detects the card. It seems the phy driver is not needed.

Now I have the problem that the card does not scan, and it does not
associate to any AP.

-- 
Fabio Andrés Correa Durán
http://facorread.150m.com
