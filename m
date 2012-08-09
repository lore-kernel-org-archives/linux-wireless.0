Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55556 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759376Ab2HITnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 15:43:43 -0400
Received: by bkwj10 with SMTP id j10so324940bkw.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 12:43:41 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Marco Fonseca <marco@tampabay.rr.com>
Subject: Re: carl9170: Unintentional transmission in monitor mode?
Date: Thu, 9 Aug 2012 21:43:28 +0200
Cc: linux-wireless@vger.kernel.org
References: <20120809165434.GA13409@192.168.1.10>
In-Reply-To: <20120809165434.GA13409@192.168.1.10>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201208092143.28506.chunkeey@googlemail.com> (sfid-20120809_214346_909325_DCA204F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, August 09, 2012 06:54:34 PM Marco Fonseca wrote:
> Hello All,
> 
> I've noticed unexpected transmissions from the AR9170 while in monitor mode
> and using tcpdump (and sometimes without tcpdump running).  These
> transmissions degrade (pretty significantly) performance of other STA/AP on
> the channel (as seen by iperf going from 60mbit/s to almost nill).  As best I
> can tell these transmissions never coalesces into an actual frame in the air
> (at least not one I'm able to pick up with a second different adapter in
> monitor mode).
> 
> Are there any known reasons/bugs on this?  Is there anyway to completely
> silence the transmitter of the AR9170 while still allowing reception?
> 
yes. <http://www.spinics.net/lists/linux-wireless/msg88896.html>

a solution is described in:
<http://www.spinics.net/lists/linux-wireless/msg89279.html>

(iw dev wlanX set monitor none - if I'm not mistaken)

Regards,
	Chr
