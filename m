Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39969 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935480Ab3DKRal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 13:30:41 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC] [PATCH 2/2 v2] NFC: RFKILL support
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1365678562-5583-3-git-send-email-sameo@linux.intel.com>
Date: Thu, 11 Apr 2013 10:30:38 -0700
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Linux NFC" <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Message-Id: <737A0683-68F6-4088-8F40-B84C496EACBA@holtmann.org> (sfid-20130411_193056_881726_4E7D0E64)
References: <1365678562-5583-1-git-send-email-sameo@linux.intel.com> <1365678562-5583-3-git-send-email-sameo@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

> All NFC devices will now get proper RFKILL support as long as they provide
> some dev_up and dev_down hooks. Rfkilling an NFC device will bring it down
> while it is left to userspace to bring it back up when being rfkill unblocked.
> This is very similar to what Bluetooth does.

this is almost a literal copy of my Bluetooth RFKILL patch ;)

> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
> include/net/nfc/nfc.h |    2 ++
> net/nfc/core.c        |   38 ++++++++++++++++++++++++++++++++++++++
> 2 files changed, 40 insertions(+)

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel

