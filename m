Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:48029 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbZAMUAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 15:00:08 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: p54usb and hostapd
Date: Tue, 13 Jan 2009 21:00:13 +0100
Cc: linux-wireless@vger.kernel.org
References: <496CECD6.5060802@gmail.com>
In-Reply-To: <496CECD6.5060802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901132100.13345.chunkeey@web.de> (sfid-20090113_210905_413146_9FFE728D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 January 2009 20:34:46 Artur Skawina wrote:
> MGMT (TX callback) ACK
> STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
> MGMT (TX callback) fail
> mgmt::proberesp cb
> STA xx:xx:xx:xx:xx:53 sent probe request for broadcast SSID
> MGMT (TX callback) fail
> mgmt::proberesp cb
> STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
> MGMT (TX callback) fail
> mgmt::proberesp cb
> STA xx:xx:xx:xx:xx:fc sent probe request for broadcast SSID
> MGMT (TX callback) fail

Oh, don't worry, this not really a failure.
"MGMT (TX callback) fail" just says that the frame was not acked by the station.
And this is OK for probe responds...  so nothing has run out of memory (yet). 

Regards,
	Chr
