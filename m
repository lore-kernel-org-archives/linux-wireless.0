Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47551 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1DAHvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 03:51:42 -0400
Received: by fxm17 with SMTP id 17so2420760fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 00:51:41 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Realman Namingston <realname1776@gmail.com>
Subject: Re: bad packets in monitor mode with ar9170 devices
Date: Fri, 1 Apr 2011 09:51:42 +0200
Cc: linux-wireless@vger.kernel.org
References: <AANLkTi=pWrS9jK1obHLiXu+oLK6YS00fG-YQqzUieYH7@mail.gmail.com>
In-Reply-To: <AANLkTi=pWrS9jK1obHLiXu+oLK6YS00fG-YQqzUieYH7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104010951.42502.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 01 April 2011 05:12:45 Realman Namingston wrote:
> ar9170-based devices record a fair amount of bad packets in monitor
> mode both with the old ar9170usb and new carl9170 drivers. The packets
> contain random BSSIDs, some measure of additional random data, and
> seem to scale proportional to the amount of traffic occurring on the
> observed channel. This behavior makes the devices rather unattractive
> for use in Kismet and site survey applications.
> 
> I assume this is due to a shortcoming of the hardware.. but is there
> any potential fix possible?
no, you misunderstood that completely: it's a shortcoming of kismet!

quote:
"Usually the wireless adapter is unable to transmit in monitor mode and
is restricted to a single wireless channel, though this is dependent on
the wireless adapter's driver, its firmware, and its chip set's features.
Also, in monitor mode the adapter does not check to see if the cyclic
redundancy check (CRC) values are correct for packets captured, so some
captured packets may be corrupted."

http://en.wikipedia.org/wiki/Monitor_mode
