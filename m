Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:36789 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbcA2XRU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 18:17:20 -0500
MIME-Version: 1.0
In-Reply-To: <wrfjk2ms465z.fsf@redhat.com>
References: <20160129172908.GA14077@Karyakshetra> <wrfjk2ms465z.fsf@redhat.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 30 Jan 2016 10:17:00 +1100
Message-ID: <CAGRGNgWQvdfQc-L9z0NKCyCOorxU0seQ-XvYnZDBWA3QKySrRA@mail.gmail.com> (sfid-20160130_001738_992963_59805BA0)
Subject: Re: [PATCH] staging: rtl8723au: Fixes unnecessary return warning
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Andreas Ruprecht <andreas.ruprecht@fau.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bhaktipriya,

On Sat, Jan 30, 2016 at 5:00 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Bhaktipriya Shridhar <bhaktipriya96@gmail.com> writes:
>> This patch fixes checkpatch.pl warning in rtw_mlme_ext.c file.
>> WARNING: void function return statements are not generally useful
>>
>> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
>> ---
>>  drivers/staging/rtl8723au/core/rtw_mlme_ext.c | 10 ----------
>>  1 file changed, 10 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
>> index d28f29a..e8a16b9 100644
>> --- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
>> +++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
>> @@ -2657,7 +2657,6 @@ static void issue_probersp(struct rtw_adapter *padapter, unsigned char *da)
>>
>>       dump_mgntframe23a(padapter, pmgntframe);
>>
>> -     return;
>>  }
>
> If you insist on pushing this rather unncessary change, please do it
> properly, and remove the blank line before the return statement as well.

As Jes said, you need to remove the blank lines before the returns
too. checkpatch should have picked this up, you did run the patch
through checkpatch before you sent it, right?

Jes,

I know you have strong feelings on coding style, but there are a lot
of people out there who see deviations from the standard as bugs to be
fixed, so stuff like this isn't going to stop until it matches the
coding style document's spec.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
