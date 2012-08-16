Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm16-vm0.bullet.mail.ird.yahoo.com ([77.238.189.192]:24383 "HELO
	nm16-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750999Ab2HPLIu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 07:08:50 -0400
Message-ID: <1345115328.54417.YahooMailNeo@web29702.mail.ird.yahoo.com> (sfid-20120816_130854_048672_3174A5C6)
Date: Thu, 16 Aug 2012 12:08:48 +0100 (BST)
From: Dani Camps <danicamps81@yahoo.com>
Reply-To: Dani Camps <danicamps81@yahoo.com>
Subject: Forcing wi-fi chipset to sleep from bcm4329 driver
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I would like to be able to control the power state (i.e. sleep/awake) of a broadcom wi-fi chipset controlled by the bcm4329 driver. My understanding of sleep/awake is the following: wi-fi chipsets support power saving protocols that allow them to enter into a low power state in order to save energy, this is what I understand as the sleep state. On the other hand when the chipset is fully powered and can directly receive data from the AP, this is what I understand as the chipset being in awake state.

Now, in the bcm4329 driver I have seen that the power mode of the wi-fi chipset can be configured with the parameters PM_MAX, PM_FAST and PM_OFF. My understanding though is that these are simply parameters to configure an internal power saving algorithm that is implemented in the chipset itself, e.g. if I configure PM_MAX it does not mean that the chipset will enter sleep mode immediately, but it will only do it according to a certain particular algorithm that I cannot conttol. Therefore, my question is whether it is possible to control the power state (sleep/awake) of the wi-fi chipset directly from within bcm4329.

Thanks!

Best Regards

Daniel
