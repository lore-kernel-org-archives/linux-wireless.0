Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59990 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934414AbaJ2Rhz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:37:55 -0400
Received: by mail-wi0-f172.google.com with SMTP id bs8so2386370wib.5
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:37:54 -0700 (PDT)
Message-ID: <545125E2.1050609@gmail.com> (sfid-20141029_183806_669670_6EE4F665)
Date: Wed, 29 Oct 2014 17:37:38 +0000
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-wireless@vger.kernel.org, forest@alittletooquiet.net
Subject: Re: [PATCH 01/48] staging: vt6655: s_cbFillTxBufHead remove unused
 parameters
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com> <1414226426-5811-2-git-send-email-tvboxspy@gmail.com> <20141029091559.GA5035@kroah.com>
In-Reply-To: <20141029091559.GA5035@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 29/10/14 09:15, Greg KH wrote:
> On Sat, Oct 25, 2014 at 09:39:39AM +0100, Malcolm Priestley wrote:
>> Remove the following parameters
>> PSEthernetHeader psEthHeader
>> PSKeyItem pTransmitKey
>> bool bNeedEncrypt
>>
>> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
>> ---
>>   drivers/staging/vt6655/rxtx.c | 14 ++++++--------
>>   1 file changed, 6 insertions(+), 8 deletions(-)
>
> I think this causes a build error, but I'm not quite sure, as I probably
> messed up the merge.  Can you refresh this series and resend?
>

Sorry about that, this patch in this series got into the wrong order.

I will resend shortly.

Regards

Malcolm

