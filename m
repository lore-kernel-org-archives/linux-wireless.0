Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-blr1.sasken.com ([203.200.200.72]:8196 "EHLO
	mta-blr1.sasken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab2GKMlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 08:41:06 -0400
From: DINO MYCLE <dino.mycle@sasken.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 11 Jul 2012 18:10:51 +0530
Subject: RE: Per packet TPC is it implimented ?
Message-ID: <28DA1CA8CF17234FB030B1ECF787E6B7B9339AD7A0@EXGMBX01.sasken.com> (sfid-20120711_144112_029178_ACC21386)
References: <28DA1CA8CF17234FB030B1ECF787E6B7B9339AD6D4@EXGMBX01.sasken.com>
 <4FFD63C0.6080002@net.t-labs.tu-berlin.de>
In-Reply-To: <4FFD63C0.6080002@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HI Thomas
  Thanks for the reply, so it will be for 2.4GHz ? or only for 5GHz ?

--
Thanks and Regards,
Dino Joseph Mycle, Ext: 3299, +91 9916888337
Sasken Communication Technologies Ltd.


-----Original Message-----
From: Thomas Huehn [mailto:thomas@net.t-labs.tu-berlin.de] 
Sent: Wednesday, July 11, 2012 5:00 PM
To: DINO MYCLE
Cc: linux-wireless@vger.kernel.org
Subject: Re: Per packet TPC is it implimented ?

Hi Dino,

We have implemented and evaluated TPC per packet in mac80211 based on
802.11 g/a/n Atheros hardware.
Currently we are focusing on proper rework to get it upstream.

Greetings Thomas


DINO MYCLE schrieb:

> Hello all
>   I want to know whether per packet TPC implemented in the mac80211 ? and it can be made to work in 2.4GHz ?
> 
> --
> Thanks and Regards,
> Dino
> 
> SASKEN BUSINESS DISCLAIMER: This message may contain confidential, proprietary or legally privileged information. In case you are not the original intended Recipient of the message, you must not, directly or indirectly, use, disclose, distribute, print, or copy any part of this message and you are requested to delete it and inform the sender. Any views expressed in this message are those of the individual sender unless otherwise stated. Nothing contained in this message shall be construed as an offer or acceptance of any offer by Sasken Communication Technologies Limited ("Sasken") unless sent with that express intent and with due authority of Sasken. Sasken has taken enough precautions to prevent the spread of viruses. However the company accepts no liability for any damage caused by any virus transmitted by this email.
> Read Disclaimer at http://www.sasken.com/extras/mail_disclaimer.html
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

