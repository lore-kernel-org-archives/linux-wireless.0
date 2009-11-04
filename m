Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:42751 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638AbZKDVac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 16:30:32 -0500
Received: by iwn10 with SMTP id 10so5291141iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 13:30:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <40f31dec0911041212p16cfc78eia1ab1817e425e767@mail.gmail.com>
References: <43e72e890911041204n55b54f8iace79938b40baa32@mail.gmail.com>
	<40f31dec0911041212p16cfc78eia1ab1817e425e767@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 4 Nov 2009 13:30:17 -0800
Message-ID: <43e72e890911041330j581e7bacp4e7b83a11c1de0e8@mail.gmail.com>
Subject: Re: pci_set_mwi() and ath5k
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org, Matthew Wilcox <matthew@wil.cx>,
	Stephen Hemminger <shemminger@vyatta.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 4, 2009 at 12:12 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2009/11/4 Luis R. Rodriguez <mcgrof@gmail.com>:
>> Curious if anyone recalls the issues seen with enabling MWI on ath5k.
>> I could have sworn there was some discussion on this but for the life
>> of me I cannot find it.
>>
>>  Luis
>
> Maybe this one ?
> http://osdir.com/ml/linux.drivers.ath5k.devel/2008-07/msg00088.html

That was it, thanks! For the record then Kyle pointed to this bug:

http://marc.info/?t=121430463700001&r=1&w=2

as a reference for possible issues.

  Luis
