Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53257 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2C1VsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 17:48:23 -0400
Message-ID: <4F738721.6020203@qca.qualcomm.com> (sfid-20120328_234826_631306_BB716C98)
Date: Thu, 29 Mar 2012 00:48:17 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: Ath6K crashes on boot in next-20120328
References: <20120328202835.46d82df6@pyramind.ukuu.org.uk>
In-Reply-To: <20120328202835.46d82df6@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2012 10:28 PM, Alan Cox wrote:
> 
> ASUS UX31E - boots happily without this driver, enable the driver and it
> goes boom with an error in ..start_tx.

Sorry, what do you mean with ..start_tx? Is it a function?

> Is this a known problem or should I try and grab a full trace ?

This is the first time I have heard such a problem so a stack trace
would be most helpful.

Do you know what ar600x device the Asus has?

Kalle
