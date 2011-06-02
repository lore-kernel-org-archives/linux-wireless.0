Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server83i.appriver.com ([72.32.253.104]:1777 "EHLO
	server83.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752212Ab1FBVnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 17:43:25 -0400
Subject: carl9170 noise floor calculation
From: Manuel Mendez <mmendez@srtrl.com>
Reply-To: mmendez@srtrl.com
To: linux-wireless@vger.kernel.org
Date: Thu, 02 Jun 2011 16:46:53 -0400
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1307047613.15440.8.camel@localhost.localdomain> (sfid-20110602_234329_163369_B2578A00)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are developing a product that uses a board similar to the DLink
DWA-160. We are sticking an amplifier before the usb radios. I am
pumping beacons at say -80dBm from a siggen and a program reading the
radiotap header prints them out.

I am seeing ~20dBm gain which looks right, when taking into account my
PA and the one that looks to be on the actual USB cards.

Is there a way to use the pre-gain values for noise floor calculations,
and reporting of signal strength?

Manny
