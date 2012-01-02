Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59910 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab2ABRtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 12:49:47 -0500
Message-ID: <4F01D896.7070907@qca.qualcomm.com> (sfid-20120102_184952_325767_315D3D6B)
Date: Mon, 2 Jan 2012 18:17:26 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Advertise TX/RX support for frames in AP mode
References: <20111227090353.GA14432@jouni.qca.qualcomm.com>
In-Reply-To: <20111227090353.GA14432@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/27/2011 11:03 AM, Jouni Malinen wrote:
> This is needed to fix current hostapd/wpa_supplicant AP operations for
> frame registration. P2P GO mode already advertised these, but AP mode
> was forgotten and could not be used after the hostapd/wpa_supplicant
> frame registration changes.
> 
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>

Thanks, applied.

Kalle
