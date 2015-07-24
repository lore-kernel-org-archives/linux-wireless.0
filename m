Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35364 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbGXD7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 23:59:10 -0400
Received: by lblf12 with SMTP id f12so7210022lbl.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2015 20:59:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P03KBFk+TVNF78oW=PtxMJ_bwC4sF0UoyuFUjDV+p=wYQ@mail.gmail.com>
References: <1427724860-1992-1-git-send-email-emmanuel.grumbach@intel.com>
	<loom.20150724T015627-838@post.gmane.org>
	<CANUX_P03KBFk+TVNF78oW=PtxMJ_bwC4sF0UoyuFUjDV+p=wYQ@mail.gmail.com>
Date: Fri, 24 Jul 2015 06:59:09 +0300
Message-ID: <CANUX_P3zn1tTjL=G7dgWuf8Yj4Pi2Xb4PpGW+1r5e--dtA6-0A@mail.gmail.com> (sfid-20150724_055914_520129_047D1D8E)
Subject: Re: [RFC 0/5] cfg80211 / mac80211: add support for Neighbor Awareness Networking
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: QH <qiumin.hu@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 24, 2015 at 6:53 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Fri, Jul 24, 2015 at 2:59 AM, QH <qiumin.hu@gmail.com> wrote:
>>
>> Emmanuel Grumbach <emmanuel.grumbach@...> writes:
>>
>>
>> ++++++++++++++++++++++++++++++++++++++++++-
>> >  net/wireless/rdev-ops.h      |  57 +++++
>> >  net/wireless/trace.h         |  77 +++++++
>> >  net/wireless/util.c          |   9 +-
>> >  19 files changed, 1126 insertions(+), 11 deletions(-)
>> >
>>
>> where can I get these patches?
>>
>> thanks,
>
> These patches were't merged because they were sent as an RFC only. The
> API towards the OS aren't clear (to me) yet, so it seems a bit
> premature to build the user space API for that. But this RFC series
> looks like a good start.

You can always apply the patches on your kernel source if you want
though. You can find them in patchwork, or alike.
