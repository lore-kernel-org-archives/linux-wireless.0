Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60798 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754584AbcJUNOV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 09:14:21 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: fix some sphinx warnings
In-Reply-To: <1477054872.4068.43.camel@sipsolutions.net>
References: <1477054644-5945-1-git-send-email-jani.nikula@intel.com> <1477054872.4068.43.camel@sipsolutions.net>
Date: Fri, 21 Oct 2016 16:14:09 +0300
Message-ID: <87h985q1y6.fsf@intel.com> (sfid-20161021_151425_490512_CAD9F66C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 21 Oct 2016, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2016-10-21 at 15:57 +0300, Jani Nikula wrote:
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>> ---
>>  include/net/mac80211.h | 21 +++++++++++++--------
>>  1 file changed, 13 insertions(+), 8 deletions(-)
>> 
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index a810dfcb83c2..e2dba93e374f 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -811,14 +811,18 @@ enum mac80211_rate_control_flags {
>>   * in the control information, and it will be filled by the rate
>>   * control algorithm according to what should be sent. For example,
>>   * if this array contains, in the format { <idx>, <count> } the
>> - * information
>> + * information::
>> 
> [...]
>
> interesting, are these not enabled by default?

rst wants indented blocks to be separated by blank lines from the
preceding and following blocks. For that you could just add the blank
lines, and it'll work.

I presumed this was nicer as preformatted/monospaced text, and for that
you'll need the "::". Up to you to have that or not.

> I guess I'll pick up these patches, even if they probably make things
> worse in my tree, since there it's still using docbook. But once we
> merge everything it should be good then.

Oh, it's built as reStructuredText in Linus' tree. Again, up to you.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
