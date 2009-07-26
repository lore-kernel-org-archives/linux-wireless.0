Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:60999 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbZGZClG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 22:41:06 -0400
Received: by bwz28 with SMTP id 28so2030087bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 19:41:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907160913i40c8341fo13b75b38b2700055@mail.gmail.com>
References: <bcd1ba70907142125y35c78cf5v251953eafede0e74@mail.gmail.com>
	 <1247673740.17896.1983.camel@rc-desk>
	 <1247674310.10754.19.camel@johannes.local>
	 <43e72e890907150925p51c1a019r95266cbdc1e762e4@mail.gmail.com>
	 <bcd1ba70907152058m14249f40gf0ebff1620e56674@mail.gmail.com>
	 <43e72e890907160913i40c8341fo13b75b38b2700055@mail.gmail.com>
Date: Sat, 25 Jul 2009 19:41:04 -0700
Message-ID: <bcd1ba70907251941w725c2e6l77870a3157f48d17@mail.gmail.com>
Subject: Re: Unable to load iwlagn module: Failed to register hw (error -17)
From: John Ranson <ranson@analager.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Running wireless testing directly fixed this issue.

John

On Thu, Jul 16, 2009 at 9:13 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Wed, Jul 15, 2009 at 8:58 PM, John Ranson<ranson@analager.net> wrote:
>> The release is master-2009-07-08-3-g3615cdf
>>
>> /sys/class/ieee80211/ is empty
>>
>> I'm running Gentoo on an Lenovo R61. I don't think that there is
>> anything too special about my configuration.
>>
>> Is there any more information that I can provide that will help debug?
>
> You can try wireless-testing directly:
>
> http://wireless.kernel.org/en/developers/Documentation/git-guide
>
>  Luis
>
