Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37605 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3DJWOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 18:14:22 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [linux-nfc] [RFC] [PATCH] NFC: RFKILL support
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20130410220920.GA10780@zurbaran>
Date: Wed, 10 Apr 2013 15:14:18 -0700
Cc: "Berg, Johannes" <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@lists.01.org>,
	Marcel Holtmann <marcel.holtmann@intel.com>
Message-Id: <FA7B2F3C-4D90-407A-999B-44B87BC851F9@holtmann.org> (sfid-20130411_001425_320870_F958B0DD)
References: <20130410220920.GA10780@zurbaran>
To: Samuel Ortiz <sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

> All NFC devices will now get proper RFKILL support as long as they provide
> some dev_up and dev_down hooks. Rfkilling an NFC device will bring it down
> while it is left to userspace to bring it back up when being rfkill unblocked.
> This is very similar to what Bluetooth does.
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
> include/net/nfc/nfc.h       |    2 ++
> include/uapi/linux/rfkill.h |    1 +
> net/nfc/core.c              |   38 ++++++++++++++++++++++++++++++++++++++
> net/rfkill/core.c           |    4 +++-

you might want to split this into 2 patches. One for adding the RFKILL pieces and the other for adding RFKILL support to the NFC subsystem.

Regards

Marcel

