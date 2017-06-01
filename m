Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33100 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdFAM7g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 08:59:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Add BMI parameters to fix calibration from DT/pre-cal
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1495709483-29793-1-git-send-email-akolli@qti.qualcomm.com>
References: <1495709483-29793-1-git-send-email-akolli@qti.qualcomm.com>
To: <akolli@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        <akolli@codeaurora.org>, <linux-wireless@vger.kernel.org>
Message-ID: <71eb9446428744b58d1571a19d4fb845@eusanexr01a.eu.qualcomm.com> (sfid-20170601_145939_112318_F7BA2A54)
Date: Thu, 1 Jun 2017 05:59:31 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

akolli@qti.qualcomm.com wrote:

> QCA99X0, QCA9888, QCA9984 supports calibration data in
> either OTP or DT/pre-cal file. Current ath10k supports
> Calibration data from OTP only.
> 
> If caldata is loaded from DT/pre-cal file, fetching board id
> and applying calibration parameters like tx power gets failed.
> 
> error log:
> [   15.733663] ath10k_pci 0000:01:00.0: failed to fetch board file: -2
> [   15.741474] ath10k_pci 0000:01:00.0: could not probe fw (-2)
> 
> This patch adds calibration data support from DT/pre-cal
> file.  Below parameters are used to get board id and
> applying calibration parameters from cal data.
> 
> 		EEPROM[OTP]	FLASH[DT/pre-cal file]
> Cal param	0x700		0x10000
> Board id	0x10		0x8000
> 
> Tested on QCA9888 with pre-cal file.
> 
> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

a9f5f287fa1d ath10k: add BMI parameters to fix calibration from DT/pre-cal

-- 
https://patchwork.kernel.org/patch/9748097/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
