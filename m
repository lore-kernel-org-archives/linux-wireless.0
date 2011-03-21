Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1530 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab1CUSiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 14:38:21 -0400
From: "Brett Rudley" <brudley@broadcom.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Dowan Kim" <dowan@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>
cc: wireless <linux-wireless@vger.kernel.org>
Date: Mon, 21 Mar 2011 11:38:07 -0700
Subject: RE: Logs spammed by brcm80211
Message-ID: <7A94256FD72B884D9E7C55586C3CBCEE16C2F5F8A9@SJEXCHCCR01.corp.ad.broadcom.com>
References: <4D878FBC.5010204@lwfinger.net>
In-Reply-To: <4D878FBC.5010204@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> With both BCM4313 and BCM943224 cards, brcm80211 spams my logs with
> messages:
> 
> wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 159/256 dur
> 1778/1504
> wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 137/256 dur
> 1602/1504
> wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 382/256 dur
> 3562/1504
> 
> Thanks,
> 
> Larry

Thanks for the heads up, we'll look into it.

Brett


