Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54377 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab0FGW2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 18:28:34 -0400
Received: by wyi11 with SMTP id 11so2777570wyi.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jun 2010 15:28:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1275946462.1835.9324.camel@rchatre-DESK>
References: <1275938438.29978.23.camel@jlt3.sipsolutions.net>
	<1275946462.1835.9324.camel@rchatre-DESK>
Date: Mon, 7 Jun 2010 18:28:32 -0400
Message-ID: <AANLkTil6h6yw_Tavm1_FLePj10SuV8CXre3cl1WKs6iT@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: add missing rcu_read_lock
From: Miles Lane <miles.lane@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested.  Looks good.

On Mon, Jun 7, 2010 at 5:34 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Mon, 2010-06-07 at 12:20 -0700, Johannes Berg wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> Using ieee80211_find_sta() needs to be under
>> RCU read lock, which iwlwifi currently misses,
>> so fix it.
>>
>> Cc: stable@kernel.org
>> Reported-by: Miles Lane <miles.lane@gmail.com>
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>
> Acked-by: Reinette Chatre <reinette.chatre@intel.com>
>
> Reinette
>
>
>
