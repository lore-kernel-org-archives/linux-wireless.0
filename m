Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1246 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997Ab2EGKGa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:06:30 -0400
Message-ID: <4FA79E99.9020900@broadcom.com> (sfid-20120507_120635_886317_5DE21537)
Date: Mon, 7 May 2012 12:06:17 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Andrei Emeltchenko" <andrei.emeltchenko.news@gmail.com>,
	"David Miller" <davem@davemloft.net>, dh.herrmann@googlemail.com,
	gustavo@padovan.org, linville@tuxdriver.com,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix coding style
References: <1336157988-4602-1-git-send-email-gustavo@padovan.org>
 <20120506.123656.1335354317428258137.davem@davemloft.net>
 <CANq1E4TTfDxZPsOqqWUT7PqTKUr8nCTC-wo=iGe_pxoUmnecgQ@mail.gmail.com>
 <20120506.145304.1998242927519675381.davem@davemloft.net>
 <20120507081411.GA19002@aemeltch-MOBL1> <4FA78618.4050203@broadcom.com>
 <20120507082945.GB19002@aemeltch-MOBL1>
In-Reply-To: <20120507082945.GB19002@aemeltch-MOBL1>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/2012 10:29 AM, Andrei Emeltchenko wrote:
> Hi Arend,
> 
> On Mon, May 07, 2012 at 10:21:44AM +0200, Arend van Spriel wrote:
>> On 05/07/2012 10:14 AM, Andrei Emeltchenko wrote:
>>>> They don't.  All the examples you'll find are of the form:
>>>>>
>>>>> 	if (a &&
>>>>> 	    b)
>>>>>
>>>>> not:
>>>>>
>>>>> 	if (a &&
>>>>> 			b)
>>> Actually it does not look like this, otherwise "b" would be placed in the
>>> same line, don't it?
>>
>> Let me rephrase Dave's remark so you may understand:
>>
>> 	if (a_has_to_be_long_enough_to_make_you_understand &&
>> 	    you_do_not_care_about_code_readability)
>>
>> and not:
>> 	if (a_has_to_be_long_enough_to_make_you_understand &&
>> 			you_do_not_care_about_code_readability)
> 
> You seems to forgot to reply to the main question about Codying Style.
> 
> Best regards 
> Andrei Emeltchenko 

True. But you explicitly addressed that one to David. The alignment rule
is indeed not stated in CodingStyle document, but using a seemingly
random amount of tabs is obviously not improving readability. I suppose
the alignment rule with an example could be added to the CodingStyle.

Gr. AvS


