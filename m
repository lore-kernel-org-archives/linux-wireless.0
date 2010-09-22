Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpauth04.prod.mesa1.secureserver.net ([64.202.165.95]:43768
	"HELO smtpauth04.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754473Ab0IVSxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 14:53:16 -0400
Message-ID: <17C3A91990E745E6A0192E2ACC311504@ChuckPC>
From: "Chuck Crisler" <ccrisler@vgocom.com>
To: <linux-wireless@vger.kernel.org>
Subject: RSN security and WPA_SUPPLICANT
Date: Wed, 22 Sep 2010 14:53:09 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am running WPA_SUPPLICANT 0.6.10. I am testing on a network with
WPA/PSK security. However, someone else is testing with a different
network overlaid on mine that uses a Radius server. That network uses
the same APs but a different SSID. The APs are Cisco, AirLAN (or
something like that). At the moment, my code is not setup to handle that
kind of security. However, I am seeing a line 'proto=3DRSN' that is
being added to most/all network sections of the supplicant configuration
file, even when my UI code hasn't instructed the supplicant to update
the file. Needless to say, this is causing hopping to fail due to
security authentication failure. I don't understand why, but I am able
to initially associate with an AP on the network, I just can't hop. Is
this a known problem with this release? Is there something that I can do
to supress this behavior?

Thank you,
Chuck Crisler

