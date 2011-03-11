Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.3eti.com ([65.220.88.139]:32820 "EHLO 3eSpam.3eti.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751041Ab1CKRVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 12:21:08 -0500
From: Chaoxing Lin <CLin@3eti.com>
To: 'Rafa? Mi?ecki' <zajec5@gmail.com>
CC: "Chen, Xianwen" <xianwen.chen@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Brett Rudley <brudley@broadcom.com>
Subject: RE: Status of Broadcom 4353?
Date: Fri, 11 Mar 2011 17:21:04 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D0572276D@RockMX01.rock.corp>
References: <AANLkTimrW002Q86KWOdh0SYsZ5xLDve+gxmwehe4tc6N@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE15B0286A4E@SJEXCHCCR01.corp.ad.broadcom.com>
	<AANLkTimViaDbvpTEmRR=Te=TGUMjc76-g5Nu-E7dYEff@mail.gmail.com>
	<4D798863.2060303@lwfinger.net>
	<AANLkTim3c200SL3icCMV7VGcyEaBQ3d6b19vSOerThib@mail.gmail.com>
	<4D7A3EAD.10306@lwfinger.net>
	<AANLkTi=X6W1E40FmjtcLBvnOQ_B98ENd-zvQH=PxmTV5@mail.gmail.com>
	<AANLkTi=wGhWvzqRxEj2eeXm0X0ZfefN-ifNe_cpm6tA+@mail.gmail.com>
	<BD54DDEB2546894FAB0731EA7B0EDF8D05722753@RockMX01.rock.corp>
 <AANLkTimoOd-A8_sy97hGDLyb4C6MUp1Lo24UdhwAiC0L@mail.gmail.com>
In-Reply-To: <AANLkTimoOd-A8_sy97hGDLyb4C6MUp1Lo24UdhwAiC0L@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-2"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, just throw some ideas. Not mean to mess.
Older Broadcom driver did put firmware in /lib/firmware/ e.g. BCM2033-FW.bin

-----Original Message-----
From: Rafa³ Mi³ecki [mailto:zajec5@gmail.com] 
Sent: Friday, March 11, 2011 12:02 PM
To: Chaoxing Lin
Cc: Chen, Xianwen; linux-wireless@vger.kernel.org; Larry Finger; Brett Rudley
Subject: Re: Status of Broadcom 4353?

W dniu 11 marca 2011 17:58 u¿ytkownik Chaoxing Lin <CLin@3eti.com> napisa³:
> Try to put firmware in
> /lib/firmware/ instead of /lib/firmware/brcm/ which is the located in the git tree, but NOT necessarily the location the driver is looking for.

It is. Please, don't mess.

-- 
Rafa³
