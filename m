Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37149 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbbCZSda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 14:33:30 -0400
Message-ID: <551450EE.5010700@gmail.com> (sfid-20150326_193743_957548_45882A1C)
Date: Thu, 26 Mar 2015 18:33:18 +0000
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>
CC: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: vnt_rf_setpower: fix missing rate RATE_12M
References: <1425746197-6614-1-git-send-email-tvboxspy@gmail.com> <20150326152213.GA4668@charon.olymp>
In-Reply-To: <20150326152213.GA4668@charon.olymp>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 26/03/15 15:22, Luis Henriques wrote:
> Hi Malcolm,
>
> On Sat, Mar 07, 2015 at 04:36:37PM +0000, Malcolm Priestley wrote:
>> When the driver sets this rate a power of zero value is set causing
>> data flow stoppage until another rate is tried.
>>
>> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
>> Cc: <stable@vger.kernel.org> # v3.17+
>
> Is there a reason for this patch being tagged for stable v3.17+ ?
Hi Luis

Sorry I thought it wouldn't apply to 3.16.

I need to do a backport patch for earlier kernels.

Regards

Malcolm

