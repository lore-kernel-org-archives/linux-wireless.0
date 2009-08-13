Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46246 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbZHMNKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 09:10:52 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH v3] b43: Implement RC calibration for rev.0/1 LP-PHYs
Date: Thu, 13 Aug 2009 15:10:48 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A8404B6.2070902@gmail.com>
In-Reply-To: <4A8404B6.2070902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908131510.48958.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 13 August 2009 14:19:02 Gábor Stefanik wrote:
> Also implement get/set BB mult, get/set TX gain, set RX gain,
> disable/restore CRS, run/stop DDFS, RX IQ est and QDIV roundup
> in the process.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> Changes from v2->v3:
> -Two small spec updates/typo fixes, as suggested by Larry.
> 
> Changes from v1->v2:
> -Coding style fixes as suggested by Michael.
> -Added missing static to lpphy_qdiv_roundup.
> -Moved set_tx_power_control & related functions before rev0/1 RC calibration,
>  and removed forward declaration
> -Reordered variable declarations at the start of rev0_1_rc_calib.
> -The ideal power table is now static const.
> 
> Interdiff v1->v2 available @ http://b43.pastebin.com/f5fe6ba3c for easier review.
> 

Acked-by: Michael Buesch <mb@bu3sch.de>


-- 
Greetings, Michael.
