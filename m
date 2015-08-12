Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:32912 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbbHLWCV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 18:02:21 -0400
Received: by obbhe7 with SMTP id he7so23685940obb.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2015 15:02:20 -0700 (PDT)
Subject: Re: Wireless driver issue
To: Sean Richards <fuzzylr@icloud.com>
References: <BY1PR09MB061612E4649D00B899E62DF9B57E0@BY1PR09MB0616.namprd09.prod.outlook.com>
 <55CB88DC.9070502@lwfinger.net>
 <BY1PR09MB0616CB744753A6CE34AA0DB2B57E0@BY1PR09MB0616.namprd09.prod.outlook.com>
 <3wfi1r0051B0Yuh01wiv6t@mac.com>
 <6FF30372-1A87-41BB-9BFC-1E92FE9FC51C@icloud.com>
Cc: "Richards, Sean" <srichards@gpo.gov>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ft86drifter@cox.net" <ft86drifter@cox.net>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55CBC237.7000006@lwfinger.net> (sfid-20150813_000224_938324_98770F39)
Date: Wed, 12 Aug 2015 17:01:27 -0500
MIME-Version: 1.0
In-Reply-To: <6FF30372-1A87-41BB-9BFC-1E92FE9FC51C@icloud.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2015 03:51 PM, Sean Richards wrote:
>
> I was wondering if you could answer one more question for me.  Would you mind expanding on this comment??
>
> It will taint your kernel
>
> I am curious what you mean by that.

When you load a driver that is not open source with the corresponding GPL 
license, a flag in the kernel is set in the kernel. If a kernel oops is later 
triggered, the dump shows that the kernel is so tainted. No kernel developer 
will look at that report until you reproduce it without loading the offending 
driver.

Larry


