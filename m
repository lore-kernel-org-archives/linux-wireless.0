Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:28000 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZA1LyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 06:54:14 -0500
Received: by fg-out-1718.google.com with SMTP id 13so527359fge.17
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 03:54:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1233137791.3936.0.camel@johannes.local>
References: <1233095278-5850-1-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-2-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-3-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-4-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-5-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-6-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-7-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-8-git-send-email-reinette.chatre@intel.com>
	 <1233137791.3936.0.camel@johannes.local>
Date: Wed, 28 Jan 2009 13:54:12 +0200
Message-ID: <1ba2fa240901280354g2c5d47e1q93ed9e9a747d381f@mail.gmail.com> (sfid-20090128_125416_509423_B1FE35F0)
Subject: Re: [PATCH 7/7] iwlwifi: unify iwlagn and 3945 power save management
From: Tomas Winkler <tomasw@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 28, 2009 at 12:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2009-01-27 at 14:27 -0800, Reinette Chatre wrote:
>> From: Winkler, Tomas <tomas.winkler@intel.com>
>>
>> This patch unifies 3945 and iwlagn power save management
>> This patch also better separates system state from user setting.
>> System state shall be removed later as this shall be shifted to user space
>
> I've got a patch to remove much of the cruft (system state and
> associated variables etc) somewhere, can dig that up if you want.

Send it over, better if it's rebased upon this one
Tomas
