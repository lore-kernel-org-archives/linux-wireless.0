Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout03.t-online.de ([194.25.134.81]:37289 "EHLO
	mailout03.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab1FJSY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 14:24:59 -0400
Message-ID: <4DF26175.2010506@t-online.de> (sfid-20110610_202502_139360_FEB5B52B)
Date: Fri, 10 Jun 2011 20:24:53 +0200
From: =?UTF-8?B?UmljaGFyZCBTY2jDvHR6?= <r.schtz@t-online.de>
MIME-Version: 1.0
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
CC: Stevie Trujillo <stevie.trujillo@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn: is tx_power_device_lmt a regulatory limit or a hardware
 limit?
References: <201105251813.36804.stevie.trujillo@gmail.com>	 <1306352560.20732.0.camel@wwguy-ubuntu>	 <201105252154.06204.stevie.trujillo@gmail.com>	 <1306376938.20732.2.camel@wwguy-ubuntu>  <4DDE1458.9090004@t-online.de>	 <1306419109.20732.6.camel@wwguy-ubuntu>  <4DF246D1.9000107@t-online.de> <1307727083.13397.57.camel@wwguy-huron>
In-Reply-To: <1307727083.13397.57.camel@wwguy-huron>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 10.06.2011 19:31, schrieb Guy, Wey-Yi:
> On Fri, 2011-06-10 at 09:31 -0700, Richard Schütz wrote:
>> On 26.05.2011 16:11, wwguy wrote:
>>> On Thu, 2011-05-26 at 01:50 -0700, Richard Schütz wrote:
>>>>> On Wed, 2011-05-25 at 12:54 -0700, Stevie Trujillo wrote:
>>>>>> On Wednesday 25 May 2011 21:42:40 wwguy wrote:
>>>>>>> On Wed, 2011-05-25 at 09:13 -0700, Stevie Trujillo wrote:
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> I have a "Intel(R) Centrino(R) 1030 BGN" card. tx_power_device_lmt is 15
>>>>>>>> and I was wondering if the card could do more than that.
>>>>>>>
>>>>>>> the card should not and will not do more than what required by
>>>>>>> regulatory
>>>>>>
>>>>>> I'm allowed to do 20dBm here and was wondering if I could make the card do
>>>>>> that.
>>>>>>
>>>>> the tx power in Intel WiFi device is regulated by uCode to make sure we
>>>>> are within regulatory limits. What country you are in?
>>>>>
>>>>> Thanks
>>>>> Wey
>>>>
>>>> I am also having the same issue with my Intel PRO/Wireless 5100 AGN.
>>>> Here in Germany I'm allowed to use 20 dBm (in the 2.4 GHz band), but the
>>>> card is limited to 15 dBm. So in some situations other cards are working
>>>> fine (as they use 20 dBm) and the Intel can't establish a connection.
>>>>
>>> We do not have different SKUs for different regions of the world. Now I
>>> understand your problem. Thank you very much for reporting. I will raise
>>> the issue and see how we should fix it.
>>>
>>> Sorry, I don't have a solution for you today. But it is very important
>>> for us and we need to result it.
>>>
>>> Thanks
>>> Wey
>>
>> Is there any news?
>>
> Hi, I talk to the marketing and since we are providing single SKU
> solution, the maximum allowed tx power is programmed in EEPROM, so
> currently there is no method to allow use the higher limitation.
>
> Thanks
> Wey

According to [1] there are no countries that forbid tx power values 
lower than 20dBm in the 2.4 GHz band. The lowest value for the 5 GHz 
band listed is 17 dBm. So why are the Intel cards limited to 15dBm then 
for both bands? This value absolutely makes no sense in my view.

[1] 
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-regdb.git;a=blob;f=db.txt;hb=HEAD

-- 
Regards,
Richard Schütz
