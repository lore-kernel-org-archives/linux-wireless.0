Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:60605 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270Ab3CDT7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 14:59:38 -0500
Received: by mail-we0-f176.google.com with SMTP id s43so4771708wey.7
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 11:59:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1362409756.21028.15.camel@jlt4.sipsolutions.net>
References: <1362204172-28307-1-git-send-email-thomas@cozybit.com> <1362409756.21028.15.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 4 Mar 2013 11:59:16 -0800
Message-ID: <CAG6hwVNuhHJ1eg0rNEkM8B-8j87bnJ7EVYqQu=HEnqzU6v5R-g@mail.gmail.com> (sfid-20130304_205941_942599_77E386F1)
Subject: Re: [PATCH 1/6] nl80211: explicit userspace MPM
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 4, 2013 at 7:09 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2013-03-01 at 22:02 -0800, Thomas Pedersen wrote:
>
>> @@ -4769,8 +4770,11 @@ static int nl80211_parse_mesh_setup(struct genl_info *info,
>>               setup->ie = nla_data(ieattr);
>>               setup->ie_len = nla_len(ieattr);
>>       }
>> +     setup->user_mpm = nla_get_flag(tb[NL80211_MESH_SETUP_USERSPACE_MPM]);
>
> Should check the feature bit here?

Oh, right.

-- 
Thomas
