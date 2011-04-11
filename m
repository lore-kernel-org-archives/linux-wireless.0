Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:33744 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab1DKPFm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 11:05:42 -0400
Date: Mon, 11 Apr 2011 17:05:34 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	users@rt2x00.serialmonkey.com
Subject: Re: Firmware for rt2800pci and rt2800usb
Message-ID: <20110411150534.GA28875@sig21.net>
References: <4DA2042A.3010301@gmail.com>
 <1302469406.5282.341.camel@localhost>
 <4DA22545.6050209@gmail.com>
 <4DA2312B.8080303@lwfinger.net>
 <4DA23594.8090002@gmail.com>
 <4DA2702B.2080305@lwfinger.net>
 <BANLkTimdBz9iSvjfkmbRS7FfgBT-Bzdk7Q@mail.gmail.com>
 <4DA2FB92.9070500@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DA2FB92.9070500@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Apr 11, 2011 at 08:01:06AM -0500, Larry Finger wrote:
> 
> They came from
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-March/003381.html
> 
> and
> 
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-March/003382.html.
> 
> These were the Ralink submissions to linux-firmware that did not get
> accepted or rejected.
> 
> Once ralinktech.com.tw comes back up, I will grab the files from
> there and make a comparison.

I had asked Ralink guys in private mail a while ago and they
said the files on ralinktech.com.tw are older.  The current
versions are those posted for linux-firmware.
(Actually I complained because each of the driver packages
contains a different version of the firmware, it's not very
clear which one is the latest one on the Ralink download site.)

Also, if you look at rt2800_check_firmware(), it seems some of
the firmware files are actually multiple different firmware
images packaged in one file.  I think this makes versioning
even more confusing.


Johannes
