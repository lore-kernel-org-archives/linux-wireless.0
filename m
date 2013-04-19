Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ye0-f176.google.com ([209.85.213.176]:45050 "EHLO
	mail-ye0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967641Ab3DSBj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 21:39:28 -0400
Message-ID: <51709E57.7020402@lwfinger.net> (sfid-20130419_033937_440655_32C6C58E)
Date: Thu, 18 Apr 2013 20:31:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Gustavo Padovan <gustavo@padovan.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	marcel@holtmann.org, johan.hedberg@gmail.com,
	linux-bluetooth@vger.kernel.org, champion_chen@realsil.com.cn
Subject: Re: [RFC/RFT PATCH 2/2] rtk_btusb: A new driver for the Bluetooth
 portion of the Realtek RTL8723AE chip
References: <1365469068-4548-1-git-send-email-Larry.Finger@lwfinger.net> <1365469068-4548-3-git-send-email-Larry.Finger@lwfinger.net> <20130418222221.GA15279@joana>
In-Reply-To: <20130418222221.GA15279@joana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/18/2013 05:22 PM, Gustavo Padovan wrote:
>
> We recently added a setup callback to btusb to run device specific
> initialization, take a look in bluetooth-next to check how that can help you
> avoid duplicate a lot of code.

Thanks for the tip. I knew something was in the planning stage.

Is there any documentation on using the new facility?

Larry


