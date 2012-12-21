Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:44955 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab2LUSKE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 13:10:04 -0500
Message-ID: <50D4A5F7.4040105@lwfinger.net> (sfid-20121221_191010_278890_11682CCD)
Date: Fri, 21 Dec 2012 12:09:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linville@tuxdriver.com, Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Champion Chen <champion_chen@realsil.com.cn>
Subject: Re: [RFC/RFT] rtk_btusb: Bluetooth driver for Realtek RTL8723AE combo
 device
References: <1356058371-17152-1-git-send-email-Larry.Finger@lwfinger.net> <1356074247.29264.11.camel@aeonflux>
In-Reply-To: <1356074247.29264.11.camel@aeonflux>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/2012 01:17 AM, Marcel Holtmann wrote:
>
> NAK. This is pretty much a blunt copy of btusb.c and not acceptable.
>
> And last time I checked, I own a big portion of btusb.c and I find it
> funny how that copyright just got replaced. 2015? Really? Time travel
> much lately ;)
>
> There have been patches for hdev->setup stage and discussions on
> creating a mini-driver approach on the mailing list. That is the way to
> go.

Marcel,

Sorry that I did not look into the copyright issue more. I knew that this was 
mostly a copy of btusb.c, and I should have been more careful. There was no 
intent on my part to steal your stuff.

I am not a subscriber to linux-bluetooth, and I have not previously seen the 
discussions/patches on the hdev->setup and mini-driver. What is the current 
status of the setup patches? I could not find them in the wireless-testing tree.

Thanks,

Larry

