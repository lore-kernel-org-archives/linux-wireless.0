Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19853 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758Ab2CTIHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 04:07:07 -0400
Message-ID: <4F683AA6.6000402@qca.qualcomm.com> (sfid-20120320_090714_690226_24BB5437)
Date: Tue, 20 Mar 2012 10:07:02 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: shonmou li <shonmou@gmail.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: avoiding 80211 scan does not complete before
 start scheduled scan.
References: <CADhJdvDbAORKoWUxLdcz7Jq2dt9DKEPzBwgmiNvZsj6iU2K9Kw@mail.gmail.com> <4F683A26.7090404@qca.qualcomm.com>
In-Reply-To: <4F683A26.7090404@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2012 10:04 AM, Kalle Valo wrote:
> On 02/23/2012 06:15 PM, shonmou li wrote:
>> In this patch, i stop 80211 scan before scheduled scan. 
>> It could avoid the following situation it will cause wpa_supplicant
>> trigger scan fail:
>>
>> "The device connected with access point then system goes into suspend mode.
>>   At this moment AP might be turned off or signal lost and then
>> disconnect with the device."
> 
> Please add a description to the commit log as well. Also can you
> describe in a bit more detail how this happens, I didn't fully
> understand the scenario. Also how often do you see this bug?

Forgot to mention that the Signed-off-by line was missing. I need it
before I can commit the patch.

More info here:

http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches

Kalle
