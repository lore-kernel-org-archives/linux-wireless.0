Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39943 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934932Ab3DKR2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 13:28:43 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC] [PATCH 1/2 v2] rfkill: Add NFC to the list of supported radios
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1365678562-5583-2-git-send-email-sameo@linux.intel.com>
Date: Thu, 11 Apr 2013 10:28:39 -0700
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Linux NFC" <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Message-Id: <58CA667F-478E-4D09-BD42-396D4DAF34F6@holtmann.org> (sfid-20130411_192853_091847_28703F96)
References: <1365678562-5583-1-git-send-email-sameo@linux.intel.com> <1365678562-5583-2-git-send-email-sameo@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

> And return the proper string for it.
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
> include/uapi/linux/rfkill.h |    2 ++
> net/rfkill/core.c           |    4 +++-
> 2 files changed, 5 insertions(+), 1 deletion(-)

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards


