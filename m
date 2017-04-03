Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54429 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbdDCJov (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 05:44:51 -0400
Subject: Re: [PATCH] wlcore: fix spelling mistake in wl1271_warning 'iligal'
 -> 'illegal'
To: Joe Perches <joe@perches.com>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20170403091530.18564-1-colin.king@canonical.com>
 <1491211256.27353.58.camel@perches.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <6473739f-5f3e-c32c-dad7-22b6c15d98cc@canonical.com> (sfid-20170403_114526_923281_209242B3)
Date: Mon, 3 Apr 2017 10:44:49 +0100
MIME-Version: 1.0
In-Reply-To: <1491211256.27353.58.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/04/17 10:20, Joe Perches wrote:
> On Mon, 2017-04-03 at 10:15 +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> trivial fix to spelling mistake in wl1271_warning error message
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  drivers/net/wireless/ti/wlcore/debugfs.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
>> index 58e148d7bc7b..416080adc181 100644
>> --- a/drivers/net/wireless/ti/wlcore/debugfs.c
>> +++ b/drivers/net/wireless/ti/wlcore/debugfs.c
>> @@ -1249,7 +1249,7 @@ static ssize_t fw_logger_write(struct file *file,
>>  	}
>>  
>>  	if (wl->conf.fwlog.output == 0) {
>> -		wl1271_warning("iligal opperation - fw logger disabled by default, please change mode via wlconf");
>> +		wl1271_warning("illegal opperation - fw logger disabled by default, please change mode via wlconf");
> 
> Hi Colin.
> 
> When you do these would you please fix all the typos on the
> same line?  opperation -> operation

Sure, I stupidly missed that.

> 
> Also, generally, invalid is a better word choice than illegal
> for these situations.

Good point.
> 
> Thanks and cheers, Joe
> 
