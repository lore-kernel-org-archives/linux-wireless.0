Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:43998 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbYH1K7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 06:59:01 -0400
Received: by ey-out-2122.google.com with SMTP id 6so95793eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2008 03:58:59 -0700 (PDT)
Message-ID: <1ba2fa240808280358u6523bc8ga758c0acf4f2ec4c@mail.gmail.com> (sfid-20080828_125908_538589_DF0A847B)
Date: Thu, 28 Aug 2008 13:58:59 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH 08/11] iwlwifi: call apm stop on exit
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Gregory Greenman" <gregory.greenman@intel.com>,
	"Mohamed Abbas" <mohamed.abbas@intel.com>
In-Reply-To: <1219928195.6064.43.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-9-git-send-email-yi.zhu@intel.com>
	 <1219927149.6064.25.camel@californication>
	 <1219920741.25321.4.camel@johannes.berg>
	 <1219928195.6064.43.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 3:56 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Johannes,
>
>> > > This patch calls apm stop on exit and suspend and sets STATUS_EXIT_PENDING
>> > > accordingly. Without this patch hardware consumes power even after driver
>> > > is removed or suspended.
>> >
>> > is this a regression to 2.6.26? That is always the important question
>> > here since that will determine if the patch should go in. If the 2.6.26
>> > version did this better (even if not prefect), then this patch should go
>> > on, otherwise it could wait until next merge window.
>>
>> AFAIR people have been complaining about this behaviour _forever_, so
>> it's hardly a regression.
>
> I think so too. However the question is still if 2.6.26 maybe did better
> and we are now doing worse because of other patches. This needs to be in
> the commit message. Otherwise this falls for me in the next merge window
> category.
>
Regression or not, this is an important bug fix.  With millions of
laptops sold this is significant contribution to global worming.
Tomas
