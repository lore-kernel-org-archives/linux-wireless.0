Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:36223 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbZBNA4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 19:56:23 -0500
Received: by yx-out-2324.google.com with SMTP id 8so723141yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 16:56:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234566111.31995.55.camel@rc-desk>
References: <1234560857-32206-1-git-send-email-reinette.chatre@intel.com>
	 <20090213224937.GE4278@tesla> <1234566111.31995.55.camel@rc-desk>
Date: Fri, 13 Feb 2009 16:56:22 -0800
Message-ID: <43e72e890902131656w36ef512el366ca47be07ba3e8@mail.gmail.com> (sfid-20090214_015640_159351_435F1C73)
Subject: Re: [PATCH] compat-2.6: reflect changes to iwlwifi Kconfig file
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 13, 2009 at 3:01 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Fri, 2009-02-13 at 14:49 -0800, Luis R. Rodriguez wrote:
>> On Fri, Feb 13, 2009 at 01:34:17PM -0800, Reinette Chatre wrote:
>> > - CONFIG_IWLWIFI is now a tristate, select it to be 'm'
>> > - CONFIG_IWLCORE has been removed
>> > - CONFIG_IWLAGN_SPECTRUM_MEASUREMENT renamed to
>> >   CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
>> > - CONFIG_IWLAGN_LEDS has been removed (not used by driver)
>> > - CONFIG_IWL3945_RFKILL does not exist
>> >
>> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>>
>> Thanks applied
>
> Please wait on this ... this patch depends on recent patch to
> wireless-testing that has not been applied yet.

OK thanks.

  Luis
