Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:42391 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753231Ab2GKLaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 07:30:10 -0400
Message-ID: <4FFD63C0.6080002@net.t-labs.tu-berlin.de> (sfid-20120711_133014_770652_5F08953B)
Date: Wed, 11 Jul 2012 13:30:08 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: DINO MYCLE <dino.mycle@sasken.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Per packet TPC is it implimented ?
References: <28DA1CA8CF17234FB030B1ECF787E6B7B9339AD6D4@EXGMBX01.sasken.com>
In-Reply-To: <28DA1CA8CF17234FB030B1ECF787E6B7B9339AD6D4@EXGMBX01.sasken.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

