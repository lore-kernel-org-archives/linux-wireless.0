Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:32852 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031243Ab3HIWIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 18:08:11 -0400
Received: by mail-oa0-f44.google.com with SMTP id l20so7566487oag.31
        for <linux-wireless@vger.kernel.org>; Fri, 09 Aug 2013 15:08:11 -0700 (PDT)
Message-ID: <52056849.9070407@lwfinger.net> (sfid-20130810_000832_036558_49B4866F)
Date: Fri, 09 Aug 2013 17:08:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Mark Schulte <schultetwin@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] rtlwifi: sparse warnings: cast to restricted type
References: <1375254507-26154-1-git-send-email-schultetwin@gmail.com> <1375254507-26154-2-git-send-email-schultetwin@gmail.com> <51F947A9.3050802@lwfinger.net> <20130809174131.GI30925@tuxdriver.com>
In-Reply-To: <20130809174131.GI30925@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2013 12:41 PM, John W. Linville wrote:
> On Wed, Jul 31, 2013 at 12:21:45PM -0500, Larry Finger wrote:
>> On 07/31/2013 02:08 AM, Mark Schulte wrote:
>>> Adding type casts to suppress sparse warnings:
>>>   * warning: cast to restricted __le32/__le16
>>>
>>> Signed-off-by: Mark Schulte <schultetwin@gmail.com>
>>> ---
>>>   drivers/net/wireless/rtlwifi/ps.c | 16 ++++++++--------
>>>   1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> I think this patch is OK, but until I get a chance to test it on a
>> big-endian machine (PowerBook G4 Titanium), please do not apply it.
>>
>> When I tried the patch, I discovered some kind of regression that
>> causes a kernel oops with an RTL8192CU device installed. This patch
>> is not the problem, but I will need to bisect the oops before I can
>> test. The machine takes a long time to build each kernel, thus it
>> will probably be a while.
>
> Any word on this?  The patch doesn't look like it should be causing
> such problems...?

I have not ywt solved the PPC crash. Unfortunately, thos processors are finicky 
and my debugging skills on that architecture are quite low. Go ahaed any apply 
this patch.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry


