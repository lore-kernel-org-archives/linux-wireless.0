Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:62637 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760139AbZC0VMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 17:12:49 -0400
Received: by wf-out-1314.google.com with SMTP id 29so1527426wff.4
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 14:12:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890903271410u4471f0b3je3308e6b65f03235@mail.gmail.com>
References: <1238113267.29544.14.camel@blob> <43e72e890903271410u4471f0b3je3308e6b65f03235@mail.gmail.com>
Date: Fri, 27 Mar 2009 14:12:32 -0700
Message-ID: <43e72e890903271412k7e5a9feexae38059cb68e792c@mail.gmail.com> (sfid-20090327_221252_686777_1AF9FB16)
Subject: Re: wireless-regdb: Update regulatory rules for Germany (DE) on 5GHz
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Bernhard Seibold <bernhard.seibold@uni-ulm.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	David Quan <David.Quan@atheros.com>,
	Michael Green <Michael.Green@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 27, 2009 at 2:10 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Mar 26, 2009 at 5:21 PM, Bernhard Seibold
> <bernhard.seibold@uni-ulm.de> wrote:
>> Hi!
>>
>> The current regdb is missing a frequency range for Germany. That
>> freq-range is military-controlled, so to be on the safe side, I asked
>> the responsible agency, and they confirmed to me that it's legal to use.
>> They also sent me the attached pdf (German only) which contains some
>> details.
>>
>> Please CC me on replies.
>
> FWIW we reviewed this internally and this matches our understanding as well. So:
>
> Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Oh John and if this patch is applied and mine are accepted as well
please note that we now need to update the sha1sum.txt file with the
sha1sum of db.txt upon each change. A change will trigger a recompile
upon running make, and generate your key if you don't have one.

  Luis
