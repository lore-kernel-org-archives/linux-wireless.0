Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43183 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1EAGjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 May 2011 02:39:03 -0400
Received: by vxi39 with SMTP id 39so3644462vxi.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Apr 2011 23:39:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinoAmna3mtMWY2Ai82wbGu-T9FzMQ@mail.gmail.com>
References: <BANLkTinoAmna3mtMWY2Ai82wbGu-T9FzMQ@mail.gmail.com>
Date: Sun, 1 May 2011 02:39:01 -0400
Message-ID: <BANLkTi=Z=i9_WoXX=YbQtF-8imKizRPM+w@mail.gmail.com> (sfid-20110501_083922_347036_FB652DA4)
Subject: Re: error initializing AR7010+AR9280 Xbox 802.11n adapter
From: Mark Davis <marked86@gmail.com>
To: George Nychis <gnychis@gmail.com>
Cc: linux-wireless@vger.kernel.org, Steven <srumney@sbcglobal.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 1, 2011 at 1:23 AM, George Nychis <gnychis@gmail.com> wrote:
> Has anyone had any experience with getting the Xbox 802.11n adapter to
> work with compat-wireless?  If not, does anyone have any suggestions
> or direction I should go in?
>
> Thanks!
> George
>

I get a bit different output testing with a genuine Xbox360 adapter
and a Datel clone:

[ 1672.480528] usb 1-1: new high speed USB device using ehci_hcd and address 26
[ 1673.124132] usb 1-1: ath9k_htc: Transferred FW: htc_7010.fw, size: 73008
[ 1673.221623] ath9k_htc 1-1:1.0: ath9k_htc: HTC initialized with 48 credits
[ 1673.260411] ath: Invalid EEPROM Magic. Endianness mismatch.
[ 1673.260442] ath: Unable to initialize hardware; initialization status: -22
[ 1673.260470] ath: Unable to initialize hardware; initialization status: -22
[ 1673.260503] Failed to initialize the device
[ 1673.270156] ath9k_htc: probe of 1-1:1.0 failed with error -22

The USB connection with the genuine Xbox360 adapter also seems to be
rather finicky.

-mark
