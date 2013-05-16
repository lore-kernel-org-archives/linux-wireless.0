Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:49616 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3EPPPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 11:15:24 -0400
Message-ID: <5194F809.6040809@lwfinger.net> (sfid-20130516_171531_929952_C2427108)
Date: Thu, 16 May 2013 10:15:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Albert Pool <albertpool@solcon.nl>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH V3] rtlwifi: rtl8192cu: Add new USB ID
References: <1368630196-14704-1-git-send-email-Larry.Finger@lwfinger.net> <5193EEA8.8030900@cogentembedded.com> <5193F146.3030206@lwfinger.net> <5194A12C.6010807@solcon.nl>
In-Reply-To: <5194A12C.6010807@solcon.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2013 04:04 AM, Albert Pool wrote:
>
> Op 15-05-13 22:34, Larry Finger schreef:
>> On 05/15/2013 03:23 PM, Sergei Shtylyov wrote:
>>> Hello.
>>>
>>> On 05/15/2013 07:03 PM, Larry Finger wrote:
>>>
>>>> From: Albert Pool <albertpool@solcon.nl>
>>>>
>>>> This adds the USB ID of the On Networks N300MA, clone of Netgear WNA3100M.
>>>>
>>>> Signed-off-by: Albert Pool <albertpool@solcon.nl>
>>>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>>>> Reported-by: Ana Rey <Anazul77@hotmail.com>
>>>> ---
>>>>
>>>> John,
>>>>
>>>> Please use this version. V2 still had some whitespace errors that I fixed.
>>>>
>>>> Albert,
>>>>
>>>> Please use scripts/checkpatch.pl to check the patch before you send it.
>>>>
>>>> Thanks,
>>>>
>>>> Larry
>>>> ---
>>>>
>>>>   drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 1 +
>>>>   1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>>>> b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>>>> index 23d640a..18da6de 100644
>>>> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>>>> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>>>> @@ -349,6 +349,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
>>>>       {RTL_USB_DEVICE(0x07aa, 0x0056, rtl92cu_hal_cfg)}, /*ATKK-Gemtek*/
>>>>       {RTL_USB_DEVICE(0x07b8, 0x8178, rtl92cu_hal_cfg)}, /*Funai -Abocom*/
>>>>       {RTL_USB_DEVICE(0x0846, 0x9021, rtl92cu_hal_cfg)}, /*Netgear-Sercomm*/
>>>> +    {RTL_USB_DEVICE(0x0846, 0xf001, rtl92cu_hal_cfg)}, /*On Netwrks N300MA*/
>>>
>>>     "Networks", perhaps? Or does it hit 80 columns limit this way?
>>
>> That is exactly the problem. I suppose I could allow one line to be 81
>> characters in length, but that would diminish the effectiveness of my
>> suggestion that checkpatch be used.
>>
>> Thanks for noticing. At least someone is reading the patches.
>>
>> Larry
>>
>>
> So my patch v2 could not be used because the line was longer than 80 chars? (It
> was 82, indeed)
>
> Also the problems with bad signal were due to Ana Rey's AP. It's being fixed or
> replaced today.

The long line was not the problem. If you run V2 through the checkpatch script, 
ypu will see that there were a number of <space><tab> sequences in the patch. 
Not only did they fail the check, but they also failed to apply on my source base.

Larry


