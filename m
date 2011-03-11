Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63750 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab1CKRBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 12:01:48 -0500
Received: by qyk7 with SMTP id 7so6057859qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2011 09:01:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D05722753@RockMX01.rock.corp>
References: <AANLkTimrW002Q86KWOdh0SYsZ5xLDve+gxmwehe4tc6N@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE15B0286A4E@SJEXCHCCR01.corp.ad.broadcom.com>
	<AANLkTimViaDbvpTEmRR=Te=TGUMjc76-g5Nu-E7dYEff@mail.gmail.com>
	<4D798863.2060303@lwfinger.net>
	<AANLkTim3c200SL3icCMV7VGcyEaBQ3d6b19vSOerThib@mail.gmail.com>
	<4D7A3EAD.10306@lwfinger.net>
	<AANLkTi=X6W1E40FmjtcLBvnOQ_B98ENd-zvQH=PxmTV5@mail.gmail.com>
	<AANLkTi=wGhWvzqRxEj2eeXm0X0ZfefN-ifNe_cpm6tA+@mail.gmail.com>
	<BD54DDEB2546894FAB0731EA7B0EDF8D05722753@RockMX01.rock.corp>
Date: Fri, 11 Mar 2011 18:01:47 +0100
Message-ID: <AANLkTimoOd-A8_sy97hGDLyb4C6MUp1Lo24UdhwAiC0L@mail.gmail.com>
Subject: Re: Status of Broadcom 4353?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Chaoxing Lin <CLin@3eti.com>
Cc: "Chen, Xianwen" <xianwen.chen@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Brett Rudley <brudley@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 11 marca 2011 17:58 użytkownik Chaoxing Lin <CLin@3eti.com> napisał:
> Try to put firmware in
> /lib/firmware/ instead of /lib/firmware/brcm/ which is the located in the git tree, but NOT necessarily the location the driver is looking for.

It is. Please, don't mess.

-- 
Rafał
