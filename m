Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.asus.com ([210.80.80.146]:28458 "EHLO ms.asus.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751382AbZCICMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 22:12:40 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Subject: RE: BCM 4325
Date: Mon, 9 Mar 2009 10:10:18 +0800
Message-ID: <79AFEBBEED459E4792B4241994B831F65819F0@TP-EX-20.corpnet.asus> (sfid-20090309_031333_190732_380CE338)
In-Reply-To: <49B3D62F.4090700@lwfinger.net>
References: <264AFFC7-5AF2-42A5-8BB8-1DEDB0255CA9@villagepublishing.com.au> <49B3D62F.4090700@lwfinger.net>
From: <Merck_Hung@asus.com.tw>
To: <Larry.Finger@lwfinger.net>, <david@villagepublishing.com.au>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Actually you can found the source code of BCM4325 in Open Source Android Repository.

But I haven't yet verify it whether is workable or not.

URL: http://android.git.kernel.org/?p=platform/system/wlan/broadcom.git;a=summary


 -----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Larry Finger
Sent: Sunday, March 08, 2009 10:29 PM
To: David Thornton
Cc: linux-wireless@vger.kernel.org
Subject: Re: BCM 4325

David Thornton wrote:
> does anyone have any info (documents, datasheet) on the bcm4325 becuase
> i would like to make a driver for it (the fm radio side of things)

What exactly is a BCM4325? It is covered by the Broadcom driver that we are
currently reverse engineering. I guessed that it was a N PHY based on the
number, but your comment would indicate a different kind of radio.

We have no datasheets for any Broadcom wireless device.

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
