Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:17529 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaCUQJx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 12:09:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Fix getting stats from firmware.
References: <1395360324-20433-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQn1B6g19Ks41kzcoVyhYbHAcJGTNAyucmPMupbRAy1SNg@mail.gmail.com>
	<532C6138.7010201@candelatech.com>
Date: Fri, 21 Mar 2014 18:09:48 +0200
In-Reply-To: <532C6138.7010201@candelatech.com> (Ben Greear's message of "Fri,
	21 Mar 2014 08:56:40 -0700")
Message-ID: <87ior7a5yr.fsf@kamboji.qca.qualcomm.com> (sfid-20140321_171031_326126_2AEEB1DE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 03/20/2014 11:33 PM, Michal Kazior wrote:
>> On 21 March 2014 01:05,  <greearb@candelatech.com> wrote:
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> Make the request command object the right size so that
>>> firmware will not just throw it away.
>>> Tested customized and upstream firmware.
>> 
>> Did you test 636 as well? 636 doesn't seem to support more than just `stats_id`.
>
> The firmware source I have checks in such a way that sending too
> large of a cmd should be fine, only too small of a command packet
> causes it to be ignored.
>
> I do not have the 636 firmware to test against.

The firmare image is here:

https://github.com/kvalo/ath10k-firmware/tree/master/main

-- 
Kalle Valo
