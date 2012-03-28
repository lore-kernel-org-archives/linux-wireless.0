Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50872 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab2C1T0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 15:26:08 -0400
Date: Wed, 28 Mar 2012 20:28:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Ath6K crashes on boot in next-20120328
Message-ID: <20120328202835.46d82df6@pyramind.ukuu.org.uk> (sfid-20120328_212635_684251_2A525021)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


ASUS UX31E - boots happily without this driver, enable the driver and it
goes boom with an error in ..start_tx.

Is this a known problem or should I try and grab a full trace ?

Alan
