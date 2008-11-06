Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:29610 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbYKFOyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 09:54:08 -0500
Received: by wf-out-1314.google.com with SMTP id 27so715888wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 06:54:06 -0800 (PST)
Message-ID: <1ba2fa240811060654w3c55bbc3ufb242a322ab5207e@mail.gmail.com> (sfid-20081106_155431_787184_435DA2BC)
Date: Thu, 6 Nov 2008 16:54:06 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2 2.6.28] iwlwifi : Fix channel scanning/association in 5Ghz band
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Marcel Holtmann" <holtmann@linux.intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Abhijeet Kolekar" <abhijeet.kolekar@intel.com>,
	"Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <1225983103.3619.242.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225912449-26625-1-git-send-email-reinette.chatre@intel.com>
	 <B887D922-0154-4365-A44D-F284A5DF9386@linux.intel.com>
	 <20081106134950.GB14184@tuxdriver.com>
	 <1225982253.3619.233.camel@johannes.berg>
	 <1ba2fa240811060647x688f1efp1728e5f80dbb6b35@mail.gmail.com>
	 <1225983103.3619.242.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 6, 2008 at 4:51 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2008-11-06 at 16:47 +0200, Tomas Winkler wrote:
>
>> The problem with missing A band is that this info was supplied to
>> driver too late. after registration otherwise
>> the iwlwifi dealt properly with missing band This was change in design
>> that wasn't reflected in the driver.
>>
>> This can happen _regardless_ of the setting of old regulatory,
>>
>> With old regulatory the channel was known prior to registration
>
> Ah, you mean the driver wasn't updated (and previously not prepared) to
> handle changing regulatory information?

Yep.
Tomas
