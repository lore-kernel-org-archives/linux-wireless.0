Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:50206 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932091Ab3BWV03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 16:26:29 -0500
Date: Sat, 23 Feb 2013 16:26:28 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Christian Lamparter <chunkeey@googlemail.com>
cc: Seth Forshee <seth.forshee@canonical.com>,
	<linux-usb@vger.kernel.org>,
	"Chen, Stephen" <scchen@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: carl9170 A-MPDU transmit problem
In-Reply-To: <201302231507.09051.chunkeey@googlemail.com>
Message-ID: <Pine.LNX.4.44L0.1302231625270.8229-100000@netrider.rowland.org> (sfid-20130223_222635_463741_80F36188)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 23 Feb 2013, Christian Lamparter wrote:

> CC'd linux-usb and Stephen.
> 
> If some folks there know how to debug these pesky usb transport
> stalls/errors?... then please join!
> (Start of the discussion was this mail:
> <http://www.spinics.net/lists/linux-wireless/msg103880.html>)

The easiest way to start is to get a usbmon trace.  See 
Documentation/usb/usbmon.txt.

Alan STern

