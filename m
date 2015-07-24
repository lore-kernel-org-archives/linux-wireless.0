Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:36002 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbbGXHpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 03:45:14 -0400
Received: by lagw2 with SMTP id w2so9151559lag.3
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2015 00:45:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P3zn1tTjL=G7dgWuf8Yj4Pi2Xb4PpGW+1r5e--dtA6-0A@mail.gmail.com>
References: <1427724860-1992-1-git-send-email-emmanuel.grumbach@intel.com>
	<loom.20150724T015627-838@post.gmane.org>
	<CANUX_P03KBFk+TVNF78oW=PtxMJ_bwC4sF0UoyuFUjDV+p=wYQ@mail.gmail.com>
	<CANUX_P3zn1tTjL=G7dgWuf8Yj4Pi2Xb4PpGW+1r5e--dtA6-0A@mail.gmail.com>
Date: Fri, 24 Jul 2015 10:45:12 +0300
Message-ID: <CANUX_P3uVqLWyCB_49Av706_WkOsmz+2B2oeOn+uC7wOZdAk4w@mail.gmail.com> (sfid-20150724_094517_855987_4C856B2C)
Subject: Re: [RFC 0/5] cfg80211 / mac80211: add support for Neighbor Awareness Networking
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: QH <qiumin.hu@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 24, 2015 at 6:59 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Fri, Jul 24, 2015 at 6:53 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> On Fri, Jul 24, 2015 at 2:59 AM, QH <qiumin.hu@gmail.com> wrote:
>>>
>>> Emmanuel Grumbach <emmanuel.grumbach@...> writes:
>>>
>>>
>>> ++++++++++++++++++++++++++++++++++++++++++-
>>> >  net/wireless/rdev-ops.h      |  57 +++++
>>> >  net/wireless/trace.h         |  77 +++++++
>>> >  net/wireless/util.c          |   9 +-
>>> >  19 files changed, 1126 insertions(+), 11 deletions(-)
>>> >
>>>
>>> where can I get these patches?
>>>
>>> thanks,
>>
>> These patches were't merged because they were sent as an RFC only. The
>> API towards the OS aren't clear (to me) yet, so it seems a bit
>> premature to build the user space API for that. But this RFC series
>> looks like a good start.
>
> You can always apply the patches on your kernel source if you want
> though. You can find them in patchwork, or alike.

One more thing - since you seem to be interested / know about NAN, I'd
love to get your insight about the proposed API.
