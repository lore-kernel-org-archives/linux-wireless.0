Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb.errno.com ([69.12.149.25]:2633 "EHLO ebb.errno.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965212AbXHaRDc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 13:03:32 -0400
Message-ID: <46D84772.4040308@errno.com>
Date: Fri, 31 Aug 2007 09:53:06 -0700
From: Sam Leffler <sam@errno.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
	Matt Norwood <norwood@softwarefreedom.org>,
	Richard Fontana <fontana@softwarefreedom.org>,
	karen sandler <karen@softwarefreedom.org>,
	Reyk Floeter <reyk@openbsd.org>,
	David Kimdon <dwhedon@devicescape.com>
Subject: Re: [PATCH] ath5k - License clarification
References: <43e72e890708310918l100326a6n6fa0c6642f4a52d4@mail.gmail.com> <43e72e890708310943x55c10044t26e6f8e16292247c@mail.gmail.com>
In-Reply-To: <43e72e890708310943x55c10044t26e6f8e16292247c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Adding some other copyright holders to the CC list
>
>   Luis
>
> On 8/31/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>   
>> Attached patch amends the ath5k license as per review from SFLC with
>> the following changes:
>>
>>   * Makes sure that Reyk's copyright and license notice appears
>>     correctly in each file that was derived from his work.
>>
>>   * Makes sure that Jiri's changes were released under a permissive,
>>     modified-BSD license, as he indicated that was his preference.
>>
>>   * Makes sure that Nick's changes were released under
>>     GPLv2-or-later, as he indicated that was his preference.
>>
>>   * Makes sure that all files clearly have the any GPL notices on
>>     top, but include the proper BSD-like notices below when required.
>>
>>    * Adds Devicescape attribution to ath5k_base.c
>>
>>   * Sets the MODULE_LICENSE to GPL, because with Nick's changes
>>     included under only GPL, the module can only be available under GPL.
>>
>>   * Adds Nick to the list of MODULE_AUTHORs because his changes
>>     are substantial.
>>
>> Signed-Off-By: Bradley M. Kuhn <bkuhn@softwarefreedom.org>
>> Signed-Off-By: Matt Norwood <norwood@softwarefreedom.org>
>> Signed-Off-By: Richard Fontana <fontana@softwarefreedom.org>
>> Signed-Off-By: Karen Sandler <karen@softwarefreedom.org>
>>
>> Acked-by: Luis R. Rodriguez <mcgrof@gmail.com>
>> Acked-by: Jiri Slaby <jirislaby@gmail.com>
>> Acked-by: Nick Kossifidis <mickflemm@gmail.com>
>>
>> Thanks to the SFLC for their help with this driver from legal hell
>>     

For the record, I told Jiri and various other folks that any code I 
licensed as dual-BSD/GPL could be made GPL only so long as the 
attribution remained.  That was the exact reason I dual-licensed.

    Sam

