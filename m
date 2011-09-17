Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.iopen.co.nz ([202.6.116.226]:53048 "EHLO mail.iopen.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab1IQBpq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 21:45:46 -0400
Message-ID: <4E73F3FA.502@iopen.net> (sfid-20110917_034554_507044_C9C96309)
Date: Sat, 17 Sep 2011 13:12:26 +1200
From: Linux Wireless Stuff for IOPEN <linwir-list@iopen.net>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Update regulatory rules for New Zealand (NZ)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From Fedora 14 :
==============

> country NZ:
>         (2402 - 2482 @ 40), (N/A, 30)
>         (5170 - 5250 @ 20), (3, 23)
>         (5250 - 5330 @ 20), (3, 23), DFS
>         (5735 - 5835 @ 20), (3, 30)

Updates for 2.4 GHz :
===================

  Frequency range is 2400 to 2483.5 (Ref 1)
  Maximum EIRP is 36 dBm (4 W)      (Ref 1)

Updates for 5 GHz :
=================

  5150 - 5250  23 dBm (200 mW) indoor only            (Ref 1,3)
  5250 - 5350  23 dBm (200 mW) indoor/outdoor,DFS+TPC (Ref 1,3)
  5725 - 5875  36 dBm (  4  W) PtMP/PtP               (Ref 1,3)
  5725 - 5825  53 dBm (200  W) PtP fixed              (Ref 1,2,3)

  And possibly this via the Spread Spectrum Device provision

  5470 - 5725  30 dBm (  1  W) requires DFS+TPC       (Ref 3)

  Maximum power density is specified for some chunks.

References :
==========
1 :
> http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-licences/fixed-radio-link-devices/information-on-the-operation-of-wireless-lan-and-related-systems-in-the-2-ghz-and-5-ghz-bands
2 :
> http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-licences/fixed-radio-link-devices
3 :
> http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-licences/short-range-devices

Cheers
The IOPEN wireless deployers

