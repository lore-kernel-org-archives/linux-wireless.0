Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:6858 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640AbYF3LZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 07:25:57 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1623714rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 04:25:57 -0700 (PDT)
Message-ID: <1ba2fa240806300425i609ababfj22a76718d3857f85@mail.gmail.com> (sfid-20080630_132601_255713_4777D759)
Date: Mon, 30 Jun 2008 14:25:57 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1 V2] cfg80211: adding NONE regdomain
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"Ester Kummer" <ester.kummer@intel.com>
In-Reply-To: <1214817730.5507.27.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214732604-4573-1-git-send-email-tomas.winkler@intel.com>
	 <43e72e890806300118me4b20bv2b91f30f91eaa7f3@mail.gmail.com>
	 <1ba2fa240806300152o6d5f7deby6d00a4421138177c@mail.gmail.com>
	 <43e72e890806300159j6c98ef9dpeac61d5aeca19f0e@mail.gmail.com>
	 <1214817730.5507.27.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 12:22 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-06-30 at 01:59 -0700, Luis R. Rodriguez wrote:
>
>> >>> This patch adds an option to enable all the channels by adding a
>> >>> value of "NONE" to ieee80211_regdom module param. This is useful
>> >>> for NICs that rely on EEPROM regulatory enforcement and for testing
>
>> > Still can be useful for testing,
>>
>> Testing can be done separately but not merged. The idea is to keep
>> mac80211 and mac80211 drivers as compliant as possible. This steers in
>> the other direction.
>
> I agree, testing is no reason to merge a patch if it's intrusive and not
> useful outside testing.

The idea was ask troubled user to make change in modprobe.conf and not
changing the code.
Thanks
Tomas
