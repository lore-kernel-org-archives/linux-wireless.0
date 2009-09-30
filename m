Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:49723 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbZI3TOL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 15:14:11 -0400
Received: by iwn8 with SMTP id 8so3832614iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2009 12:14:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1254334586.26521.1617.camel@rc-desk>
References: <4AC39D6F.5070308@canonical.com> <1254334586.26521.1617.camel@rc-desk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 30 Sep 2009 12:13:55 -0700
Message-ID: <43e72e890909301213m6c6b890fp59940f732c181686@mail.gmail.com>
Subject: Re: iwl-1000 firmware versions 1 and 2 are nowhere to be found
To: reinette chatre <reinette.chatre@intel.com>
Cc: "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2009 at 11:16 AM, reinette chatre
<reinette.chatre@intel.com> wrote:
> Hi Tim,
>
> On Wed, 2009-09-30 at 11:03 -0700, Tim Gardner wrote:
>> I've got a user complaining that the iwl-1000 firmware version required
>> by 2.6.31 doesn't exist. Indeed, IWL1000_UCODE_API_MAX is 2, yet the
>> only firmware available from http://intellinuxwireless.org/?n=Downloads
>> is iwlwifi-1000-3.ucode. Shall I just tell him to install compat-wireless ?
>>
>> BugLink: http://bugs.launchpad.net/bugs/439285
>>
>
> 2.6.31 needs a few more patches to fully support 1000 series

So just a heads up the stable compat-wireless stuff is here:

http://wireless.kernel.org/en/users/Download/stable/

I'll soon make a release based on 2.6.32-rc1, but I thought 2.6.32-rc1
was going to be busted, not sure yet, it may be. We probably should
wait for rc2.

  Luis
