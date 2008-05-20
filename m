Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:39542 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYETBXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 21:23:52 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1750091rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2008 18:23:50 -0700 (PDT)
Message-ID: <183c1cc10805191823w5855227akce4aa1bb9f1b6198@mail.gmail.com> (sfid-20080520_032356_231539_F152C448)
Date: Mon, 19 May 2008 21:23:50 -0400
From: "John Goulah" <jgoulah@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi Makefile issue in compat-wireless-2008-05-18
In-Reply-To: <1211245264.2532.24.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <183c1cc10805181143v526fcc86l4bec27b12805748f@mail.gmail.com>
	 <1211168475.31033.9.camel@debian.sh.intel.com>
	 <183c1cc10805190610h176cb8fcx54e6755fb5f36cfb@mail.gmail.com>
	 <1211245264.2532.24.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2008 at 9:01 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Mon, 2008-05-19 at 09:10 -0400, John Goulah wrote:
>>
>> Thats odd, my kernel is fairly new -- 2.6.24.4
>>
>> I custom compiled it, and I dont see anything related to IWL  in my
>> .config file strangely enough.  I guess its possible my .config got
>> out of sync somehow, or is this what you would consider "old" ?
>
> Yup, .24 is old. The patch will make its way to .26 (not released yet).
>



Ok,  I assume you mean the patch for the kernel config that allows
this all to work?

Would that mean you're not supporting compiling on any kernel older
than 2.6.26 with this change?

Thanks so much,
John
