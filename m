Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:51460 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYJVJXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 05:23:20 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2864762rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 02:23:20 -0700 (PDT)
Message-ID: <1ba2fa240810220223i4d776b16qb67bfa4bb5733899@mail.gmail.com> (sfid-20081022_112338_843591_8E81D5F8)
Date: Wed, 22 Oct 2008 11:23:19 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: New iwlwifi 3945 uCode available
Cc: "reinette chatre" <reinette.chatre@linux.intel.com>,
	"Marcel Holtmann" <holtmann@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224666883.28639.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224613633.10863.43.camel@rc-desk>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 <1224624899.28639.17.camel@johannes.berg>
	 <20081021213814.GM17268@tuxdriver.com>
	 <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
	 <1224627187.9386.103.camel@californication>
	 <1224628088.10863.100.camel@rc-desk>
	 <1224660449.28639.22.camel@johannes.berg>
	 <1ba2fa240810220210w39466f2bobd1d6b32f99b533d@mail.gmail.com>
	 <1224666883.28639.40.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 11:14 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-10-22 at 11:10 +0200, Tomas Winkler wrote:
>
>> > I really don't know why we let you get away with this and bitch
>> > endlessly when b43 does such a change, to the point where we finally
>> > cave in and support both versions. Why should a community-supported
>> > driver be held to higher standards?
>>
>> Patches that we'll support both firmwares from the cummutiy will be
>> welcome, as always.
>
> So you're saying we should let you get away with it and just fix it
> ourselves... How about you identify which patch broke it so we stand a
> chance?

01f9a21af3644224ecc899adeea31dc00418ddae
f93b673fcfe2670ccb22434d2ec7660b9f1c3fb8

 But if then we decide the breakage is worse than the new
> feature, and revert the patch, you'll scream bloody murder anyway
Revert anything you want.

so why
> do I even bother?

Don't now

 Clearly, so far there's no attempt to hold you to the
> same standards we hold community drivers to, and you are in no way
> motivated to improve our opinion of you by doing something voluntarily.

Your militant language is under my standards
Tomas
