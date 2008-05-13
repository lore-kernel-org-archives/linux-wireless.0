Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:38105 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459AbYEMX1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 19:27:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: 4311 v2 Bail - 2.6.26-rc2
Date: Wed, 14 May 2008 01:27:22 +0200
Cc: Daniel <dan@f-box.org>, linux-wireless@vger.kernel.org
References: <48294F0B.4040908@f-box.org> <200805131119.09964.mb@bu3sch.de> <482A08A5.3000204@f-box.org>
In-Reply-To: <482A08A5.3000204@f-box.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805140127.22302.mb@bu3sch.de> (sfid-20080514_012747_829356_A0E41B5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 May 2008 23:31:17 Daniel wrote:
> Hello,
> 
> Michael Buesch wrote:
> > Could you _please_ be so kind an explain your actual problem??
> > My magic crystalball is broken today.
> 
> Sorry, it's the problem where after X minutes the device seems to loose 
> the ability to communicate. It seems to be on a high number of 
> connections/sec scenario.
> 
> It seems to occur at the 2nd or 3rd issue of the "wrong buffer size" 
> message.

Where does this "wrong buffer size" message come from, and what does it mean?

> b43-phy1 debug: Using hardware based encryption for keyidx: 1, mac: 
> ff:ff:ff:ff:ff:ff
> wlan0: wrong buffer size<7>wlan0: wrong buffer size<7>wlan0: wrong 
> buffer size<7>wlan0: wrong buffer size
> b43-phy1 debug: Disabling hardware based encryption for keyidx: 1, mac: 
> ff:ff:ff:ff:ff:ff

-- 
Greetings Michael.
