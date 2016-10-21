Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:54695 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755325AbcJUNSW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 09:18:22 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: use inline kernel-doc for struct ieee80211_hw
In-Reply-To: <1477054892.4068.44.camel@sipsolutions.net>
References: <1477054644-5945-1-git-send-email-jani.nikula@intel.com> <1477054644-5945-2-git-send-email-jani.nikula@intel.com> <1477054892.4068.44.camel@sipsolutions.net>
Date: Fri, 21 Oct 2016 16:18:18 +0300
Message-ID: <87eg39q1r9.fsf@intel.com> (sfid-20161021_152005_853799_2FBA95B9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 21 Oct 2016, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2016-10-21 at 15:57 +0300, Jani Nikula wrote:
>> It's easier to manage the kernel-doc for the fields when they
>> documentation is next to the field.
>
> Hah, I wasn't even aware this was possible. Thanks!

It is indeed. And this lets you have multi-paragraph descriptions for
fields which would be impossible in the top level struct kernel-doc,
because you can't have blank lines in the field descriptions there.

Currently you can't have one line inline /** @foo: bar */ descriptions
though, the opening and closing comment markers still need to be on
their own lines. Maybe I'll get around to fixing that one of these
days...

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
