Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0118.outbound.protection.outlook.com ([157.55.234.118]:27829
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756766AbbFPIzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 04:55:17 -0400
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
Date: Tue, 16 Jun 2015 08:55:13 +0000
Message-ID: <DB5PR06MB1112E576BF6FFE240CB124C0DFA70@DB5PR06MB1112.eurprd06.prod.outlook.com> (sfid-20150616_105545_018517_D36C4113)
References: <1434439941-6369-1-git-send-email-habdul@visteon.com>
 <20150616080955.GA1007@sudip-PC>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 16 June 2015 01:40 PM, Sudip Mukherjee wrote:
> On Tue, Jun 16, 2015 at 07:33:42AM +0000, Abdul, Hussain (H.) wrote:
>> From: Abdul Hussain <habdul@visteon.com>
>>
>> This patch removes unwanted true and false from boolean tests.
>>
>> Signed-off-by: Abdul Hussain <habdul@visteon.com>
>> ---
> <snip>
>> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
>> index 17ab5cd..be1f6bf 100644
>> --- a/drivers/staging/wilc1000/host_interface.c
>> +++ b/drivers/staging/wilc1000/host_interface.c
>> @@ -7816,7 +7816,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
>>  					pNewJoinBssParam->rsn_cap[1] = pu8IEs[rsnIndex + 1];
>>  					rsnIndex += 2;
>>  				}
>> -				pNewJoinBssParam->rsn_found = 1;
>> +				pNewJoinBssParam->rsn_found = true;
> But this is not a boolean test, this is an assignement.
>
> regards
> sudip
>
Sudip,

Yes that is an assignment to the boolean variable. Do i need to modify the commit message or to send separate patch?

Thanks,
Abdul
