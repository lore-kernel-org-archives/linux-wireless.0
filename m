Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:61571 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbYLSVUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 16:20:05 -0500
Received: by qw-out-2122.google.com with SMTP id 3so343216qwe.37
        for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 13:20:04 -0800 (PST)
Message-ID: <69e28c910812191320m13ed4838of11d3d2c51f797c4@mail.gmail.com> (sfid-20081219_222025_377760_8F6A3553)
Date: Fri, 19 Dec 2008 22:20:04 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: drago01 <drago01@gmail.com>
Subject: Re: [PATCH 00/43] iwl3945 merges into iwlagn (Dec 19)
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <f6ca9fed0812191315l66cf6bd8y9630f4057dc076a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
	 <f6ca9fed0812191132h2f76ce40id20c52bdb6e0681c@mail.gmail.com>
	 <20081219205129.GD15227@tesla>
	 <f6ca9fed0812191315l66cf6bd8y9630f4057dc076a5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 19, 2008 at 10:15 PM, drago01 <drago01@gmail.com> wrote:
> On Fri, Dec 19, 2008 at 9:51 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Fri, Dec 19, 2008 at 11:32:53AM -0800, drago01 wrote:
>>> On Fri, Dec 19, 2008 at 3:37 AM, Zhu Yi <yi.zhu@intel.com> wrote:
>>> > Hi John,
>>> >
>>> > Here is the first batch for the iwl3945 -> iwlagn merge. This is for
>>> > post .29 kernel.
>>>
>>> Well it doesn't really matter but wouldn't it make sense to rename the
>>> driver back to iwlwifi ? (as 3945 does not support n mode)
>>
>> That would make compat-crap stuff difficult, at least I cannot think of an
>> easy way to deal with it. See scripts/iwl-load, part of compat-wireless. This
>> is used to simply rename iwl4965 to iwl4965.ignore and let iwlagn kick in
>> if you are on an older kernel.
>
> MODULE_ALIAS("iwlagn")
>
>> If we move iwlagn to iwlwifi... umm.. wait did
>> we ever have an "iwlwifi" driver?
>
> yes that was the original name of the driver before it was split into
> iwl3945  and iwl4965  (if I remember correctly iwlwifi was 3945 only
> and the split happend when 4965 support was added).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

What about using "iwl" or "iwl80211" as the new name? IMO "iwl" is not
too short, given that it is the same length as "b43".

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
