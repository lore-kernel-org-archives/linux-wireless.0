Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:28505 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYFSUaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 16:30:11 -0400
Received: by yw-out-2324.google.com with SMTP id 9so524598ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 13:29:56 -0700 (PDT)
Message-ID: <1ba2fa240806191329w7aef4ccaq587915d41d999edd@mail.gmail.com> (sfid-20080619_223015_776052_0312B856)
Date: Thu, 19 Jun 2008 23:29:55 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 1/2] mac80211: 11d Handling - Country Information Element
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"Assaf Krauss" <assaf.krauss@intel.com>
In-Reply-To: <1213906688.8967.112.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1213900512-21565-1-git-send-email-tomas.winkler@intel.com>
	 <1213902216.8967.78.camel@johannes.berg>
	 <1ba2fa240806191316h3ca2044o407d094415fa5bf2@mail.gmail.com>
	 <1213906688.8967.112.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 19, 2008 at 11:18 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> >> +     if (country_ie_len < 6) {
>> >> +             printk(KERN_ERR "%s: country information element shorter (%d)"
>> >> +                     " than expected.\n", __func__, country_ie_len);
>> >
>> > Remotely exploitable security bug.
>
>> Please explain,
>
> Sending broken frames will fill the disk.

I see thanks (yeah, distors doesn't make separate log partitions as default)

Tomas
