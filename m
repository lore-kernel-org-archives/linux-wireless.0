Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.188]:58243 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760447AbZJMPyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 11:54:43 -0400
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Tue, 13 Oct 2009 17:52:52 +0200
Cc: linux-wireless@vger.kernel.org,
	"linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr>
In-Reply-To: <4AD46380.9020308@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910131752.52589.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
 
> In 2.6.31, there are USB device IDs common between both drivers.

That is because they are drivers for the same hardware.

> Should  a distribution enable both drivers? What do you suggest? Are there any
> *known issues* stuff for one of them?

The staging/rt2870 should actually be removed from the kernel tree,
I am going to merge rt2800pci soon as well and after that I'll send a patch
to remove all Ralink drivers from the staging tree.

As for known issues:
- staging/rt2870 is a piece of crap which apparently works for some people
but isn't generally stable or reliable
- wireless/rt2800usb follows the kernel coding style/rules and uses mac80211
but isn't showing a high quality for usability.

Ivo
