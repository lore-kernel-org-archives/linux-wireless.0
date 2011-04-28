Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:24428 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1D1Rju (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 13:39:50 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 10:39:22 -0700
Date: Thu, 28 Apr 2011 10:39:44 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [RFC/RFT 4/9] ath9k_hw: config diversity based on eeprom
 contents
Message-ID: <20110428173944.GB29252@tux> (sfid-20110428_193952_900952_1B6D0814)
References: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com>
 <1304000579-5784-5-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1304000579-5784-5-git-send-email-mshajakhan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 28, 2011 at 07:22:54AM -0700, Mohammed Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> * enable LNA-diversity, fast-diversity based on the value read from
>   EEPROM content
> * if antenna diversity/combining is supported set LNA1 for the main
>   antenna and LNA2 for the alternate antenna based on the new diversity
>   algorithm

The commit log does not mention this is specifically only for
AR9485. Adding this can help reviewers / distributions.

  Luis
