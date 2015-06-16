Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0128.outbound.protection.outlook.com ([157.55.234.128]:42384
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751120AbbFPMYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 08:24:38 -0400
From: "Abdul, Hussain (H.)" <habdul@visteon.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Dighe, Niranjan (N.)" <ndighe@visteon.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"Ravindran, Madhusudhanan (M.)" <mravindr@visteon.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"rachel.kim@atmel.com" <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>
Subject: Re: [PATCH] Staging: wilc1000: Boolean tests don't need comparisons
Date: Tue, 16 Jun 2015 12:24:35 +0000
Message-ID: <DB5PR06MB1112DA3F0299B8678674BCE9DFA70@DB5PR06MB1112.eurprd06.prod.outlook.com> (sfid-20150616_142458_936799_F485C4C3)
References: <1434439941-6369-1-git-send-email-habdul@visteon.com>
 <20150616080955.GA1007@sudip-PC>
 <DB5PR06MB1112E576BF6FFE240CB124C0DFA70@DB5PR06MB1112.eurprd06.prod.outlook.com>
 <20150616111111.GA15479@sudip-PC>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 16 June 2015 04:41 PM, Sudip Mukherjee wrote:
> On Tue, Jun 16, 2015 at 08:55:13AM +0000, Abdul, Hussain (H.) wrote:
>> On Tuesday 16 June 2015 01:40 PM, Sudip Mukherjee wrote:
>>> On Tue, Jun 16, 2015 at 07:33:42AM +0000, Abdul, Hussain (H.) wrote:
>>>> From: Abdul Hussain <habdul@visteon.com>
>>> regards
>>> sudip
>>>
>> Sudip,
>>
>> Yes that is an assignment to the boolean variable. Do i need to modify the commit message or to send separate patch?
> if that assignment is related to the change in boolean test then it should
> be in the same patch. But in any case commit message should mention that
> change and the reason.
>
> regards
> sudip
>
>
I have sent separate patch for this change.

Thanks,
Abdul
