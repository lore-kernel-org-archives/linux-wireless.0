Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:56557 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYLSVPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 16:15:07 -0500
Received: by fg-out-1718.google.com with SMTP id 19so466045fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 13:15:05 -0800 (PST)
Message-ID: <f6ca9fed0812191315l66cf6bd8y9630f4057dc076a5@mail.gmail.com> (sfid-20081219_221512_828712_8679C87F)
Date: Fri, 19 Dec 2008 22:15:05 +0100
From: drago01 <drago01@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 00/43] iwl3945 merges into iwlagn (Dec 19)
Cc: "Zhu Yi" <yi.zhu@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20081219205129.GD15227@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
	 <f6ca9fed0812191132h2f76ce40id20c52bdb6e0681c@mail.gmail.com>
	 <20081219205129.GD15227@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 19, 2008 at 9:51 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Fri, Dec 19, 2008 at 11:32:53AM -0800, drago01 wrote:
>> On Fri, Dec 19, 2008 at 3:37 AM, Zhu Yi <yi.zhu@intel.com> wrote:
>> > Hi John,
>> >
>> > Here is the first batch for the iwl3945 -> iwlagn merge. This is for
>> > post .29 kernel.
>>
>> Well it doesn't really matter but wouldn't it make sense to rename the
>> driver back to iwlwifi ? (as 3945 does not support n mode)
>
> That would make compat-crap stuff difficult, at least I cannot think of an
> easy way to deal with it. See scripts/iwl-load, part of compat-wireless. This
> is used to simply rename iwl4965 to iwl4965.ignore and let iwlagn kick in
> if you are on an older kernel.

MODULE_ALIAS("iwlagn")

> If we move iwlagn to iwlwifi... umm.. wait did
> we ever have an "iwlwifi" driver?

yes that was the original name of the driver before it was split into
iwl3945  and iwl4965  (if I remember correctly iwlwifi was 3945 only
and the split happend when 4965 support was added).
