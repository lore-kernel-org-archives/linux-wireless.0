Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-blr1.sasken.com ([203.200.200.72]:62044 "EHLO
	mta-blr1.sasken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758476Ab2FZIco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 04:32:44 -0400
From: DINO MYCLE <dino.mycle@sasken.com>
To: sylvain_gmail <sylvain.roger.rieunier@gmail.com>,
	Kalle Valo <kvalo@adurom.com>
CC: Victor Goldenshtein <victorg@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 26 Jun 2012 13:50:20 +0530
Subject: RE: [PATCH] mac80211: add command to get current rssi
Message-ID: <28DA1CA8CF17234FB030B1ECF787E6B7B93374A1C9@EXGMBX01.sasken.com> (sfid-20120626_103250_538454_AE37806C)
References: <1337669130-4229-1-git-send-email-victorg@ti.com>
 <4FE85430.3030007@gmail.com> <87y5nb34bm.fsf@purkki.adurom.net>
 <4FE96D48.9080901@gmail.com>
In-Reply-To: <4FE96D48.9080901@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
 Adding the RSSI for each antenna will be useful. We can verify if the antenna connectors are proper or not by checking the RSSI value of each antenna, Also this will be helpful for outdoor installation where they use dual polarized antennas for PtP and PMP systems

--
Thanks and Regards,
Dino Joseph Mycle, Ext: 3299, +91 9916888337
Sasken Communication Technologies Ltd.


-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of sylvain_gmail
Sent: Tuesday, June 26, 2012 1:35 PM
To: Kalle Valo
Cc: Victor Goldenshtein; Johannes Berg; linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add command to get current rssi

it can be very useful when you installed multiple polarization antennas.
For each polarization picks up the signal on a different axis. For example for a dual polarization antenna, you have a horizontal polarization and vertical polarization.

Regards,
Sylvain

Le 25/06/2012 15:32, Kalle Valo a écrit :
> sylvain_gmail <sylvain.roger.rieunier@gmail.com> writes:
>
>> But do not you think it would be interesting to have a function that
>> returns the RSSI signal by antennas?
> Just out of interest, how would user space use that information? Do
> you have any ideas?
>


--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

SASKEN BUSINESS DISCLAIMER: This message may contain confidential, proprietary or legally privileged information. In case you are not the original intended Recipient of the message, you must not, directly or indirectly, use, disclose, distribute, print, or copy any part of this message and you are requested to delete it and inform the sender. Any views expressed in this message are those of the individual sender unless otherwise stated. Nothing contained in this message shall be construed as an offer or acceptance of any offer by Sasken Communication Technologies Limited ("Sasken") unless sent with that express intent and with due authority of Sasken. Sasken has taken enough precautions to prevent the spread of viruses. However the company accepts no liability for any damage caused by any virus transmitted by this email.
Read Disclaimer at http://www.sasken.com/extras/mail_disclaimer.html
