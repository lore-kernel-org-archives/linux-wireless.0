Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:61816 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933890Ab3GPXyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 19:54:31 -0400
Received: by mail-lb0-f176.google.com with SMTP id z5so1079753lbh.35
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 16:54:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WmcGs6u8ZCrWXcKQe=MsQk_C7R7i+x1V-cDbjQ+A8d-w@mail.gmail.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com> <CAB=NE6WmcGs6u8ZCrWXcKQe=MsQk_C7R7i+x1V-cDbjQ+A8d-w@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 16 Jul 2013 16:54:10 -0700
Message-ID: <CAB=NE6VQTVbVvQha3+UXoLwqkUTeYq5tEa5sWfFEMO-R-tOvMg@mail.gmail.com> (sfid-20130717_015435_010996_255BF3E5)
Subject: Re: [RFC 00/53] wireless-regdb: mostly VHT80 updates
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 16, 2013 at 1:18 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Wed, Jul 3, 2013 at 6:03 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
>> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>>
>> Here's a series of updates for wireless-regdb. Most of this is
>> to just enable VHT80 support to enable support for 802.11ac
>> where this has been verified to be usable. I cannot meet the
>> criteria of providing full documentation for sources for all
>> patches, only a few ones so what I recommend for the rest is
>> to let this sit on the list for a bit and I'd hope after
>> review if no one spots any issues I'd hope we can merge this.
>>
>> I reviewed the idea of vendor namespaces on wireless-regdb
>> and at least through review with pkgadd on IRC we concluded
>> its best to try to take this approach instead of encouraging
>> divergence due to any lack of full source documentation or
>> inability to provide such documentation for whatever reason.
>> This seems to be better than not getting any updates at all
>> and keeps vendors hopefully encouraged to push changes upstream.
>
> I saw one comment addressing a typo on ID, I've fixed that. If there
> are no complaints can we merge these to get VHT80?

Please hold off on these for a bit. I need to test one more thing.

  Luis
