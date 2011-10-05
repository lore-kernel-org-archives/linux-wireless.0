Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2336 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab1JEKAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 06:00:37 -0400
Message-ID: <4E8C2AB6.7060409@qca.qualcomm.com> (sfid-20111005_120041_184898_D1BF1A82)
Date: Wed, 5 Oct 2011 13:00:22 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	<dwmw2@infradead.org>, <David.Woodhouse@intel.com>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/1] linux-firmware: Add new firmware image for ath6kl
 driver
References: <1317455234-2416-1-git-send-email-senthilb@qca.qualcomm.com> <CADPsn1Zf5dwCAQuoN46zp2mHfRRmSH0fvH5Sgs-RDEjp6+anhw@mail.gmail.com>
In-Reply-To: <CADPsn1Zf5dwCAQuoN46zp2mHfRRmSH0fvH5Sgs-RDEjp6+anhw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sangwook,

On 10/04/2011 04:55 PM, Sangwook Lee wrote:
> Do you any plan to release fw-2.bin for AR6003/hw2.0 ?
> 
> I found out this firmware only for AR6003/hw2.1.1.
> But in ath6kl source code,
> You already defined as like following:
> #define AR6003_REV2_FIRMWARE_2_FILE         "ath6k/AR6003/hw2.0/fw-2.bin"
> 
> If possible, please let me have the chance to test the new firmware
> with my hw2.0 board.

We will try to get a firmware for hw2.0 as well. But that will be a
lower priority and I have no idea how it works. If you can get a ar6003
hw2.1.1 I recommend using that instead.

Kalle
