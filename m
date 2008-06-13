Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:38184 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbYFMPvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 11:51:22 -0400
Received: by an-out-0708.google.com with SMTP id d40so990432and.103
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 08:51:21 -0700 (PDT)
Message-ID: <43e72e890806130851t63887c9cy640ac70d944fc3f8@mail.gmail.com> (sfid-20080613_175127_301515_5CF05B9A)
Date: Fri, 13 Jun 2008 08:51:21 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ANNOUNCE] linux-staging tree created
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org,
	devel@linuxdriverproject.org, linux-next@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	"Stephen Rothwell" <sfr@canb.auug.org.au>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080613143328.GA16506@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080610190540.GA25066@kroah.com>
	 <43e72e890806130714k535b041evaf750209ea492c47@mail.gmail.com>
	 <20080613143328.GA16506@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 13, 2008 at 7:33 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Jun 13, 2008 at 07:14:32AM -0700, Luis R. Rodriguez wrote:
>
>> This is great. To let this be useful for wireless we'll need
>> wireless-testing.git merged as we rely on it for the latest and
>> greatest. Is this a possibility?
>
>> We have a few drivers which are not yet ready for
>> wireless-testing.git. Airgo is one.
>>
>> Anyway, good stuff. Let me know what you think about letting this work
>> for wireless too.
>
> I don't think directly pulling wireless-testing is a good idea of
> -staging for process-related reasons.  However I think we can arrange
> to send something for the new tree.  at76, airgo, and mrv8k are all
> decent candidates.
>
> Greg, how does the -staging tree get managed?  Is it periodically
> rebuilt (like -next)?  Or would I need to send you pull requests?

Its just quit patches.

  Luis
