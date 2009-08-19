Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:54754 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbZHSSux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 14:50:53 -0400
Received: by iwn42 with SMTP id 42so202793iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 11:50:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090819183506.GG5905@tuxdriver.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
	<20090819150138.GB5905@tuxdriver.com> <20090819180235.GA7126@mosca>
	<20090819183506.GG5905@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 19 Aug 2009 11:50:34 -0700
Message-ID: <43e72e890908191150h6fa8a811u30c57420afd17e08@mail.gmail.com>
Subject: Re: [PATCH v5 00/33] wireless: kconfig updates
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 11:35 AM, John W.
Linville<linville@tuxdriver.com> wrote:
> On Wed, Aug 19, 2009 at 11:02:35AM -0700, Luis R. Rodriguez wrote:
>> On Wed, Aug 19, 2009 at 08:01:38AM -0700, John W. Linville wrote:
>
>> > I'm sorry, I know you've put some effort into this.  A lot of it seems
>> > fine, even welcome.  But I don't really see the point of grouping
>> > everything by manufacturer -- it just seems to add an extra level of
>> > organization for no particular reason...?
>>
>> Well at first I didn't really intend to group them by manufacturer really,
>> I just tried to get rid of clutter and wanted to group related drivers
>> together to make it easier to find for users. After a few iterations the
>> manufacturer grouping just happened naturally, and later it also just seemed
>> natural to remove the typical postfix "wireless device support" or the like.
>>
>> I welcome others to try to clean the stuff up some more in a different
>> way but I think you may end up with something very similar.
>
> Can we just drop the "INTEL_80211" and the like, keeping the comments
> and basic organization in the Kconfig files as you have them?

Well so to group all of Intel stuff we do need this, at least I can't
think of a way to do it. If we don't want to group intel stuff then we
can remove it. Is there a downside to this grouping, for example?

  Luis
