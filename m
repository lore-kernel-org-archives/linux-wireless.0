Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36822 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbbGXDxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 23:53:22 -0400
Received: by lbbqi7 with SMTP id qi7so7105217lbb.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2015 20:53:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20150724T015627-838@post.gmane.org>
References: <1427724860-1992-1-git-send-email-emmanuel.grumbach@intel.com>
	<loom.20150724T015627-838@post.gmane.org>
Date: Fri, 24 Jul 2015 06:53:20 +0300
Message-ID: <CANUX_P03KBFk+TVNF78oW=PtxMJ_bwC4sF0UoyuFUjDV+p=wYQ@mail.gmail.com> (sfid-20150724_055328_614040_50378EA4)
Subject: Re: [RFC 0/5] cfg80211 / mac80211: add support for Neighbor Awareness Networking
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: QH <qiumin.hu@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 24, 2015 at 2:59 AM, QH <qiumin.hu@gmail.com> wrote:
>
> Emmanuel Grumbach <emmanuel.grumbach@...> writes:
>
>
> ++++++++++++++++++++++++++++++++++++++++++-
> >  net/wireless/rdev-ops.h      |  57 +++++
> >  net/wireless/trace.h         |  77 +++++++
> >  net/wireless/util.c          |   9 +-
> >  19 files changed, 1126 insertions(+), 11 deletions(-)
> >
>
> where can I get these patches?
>
> thanks,

These patches were't merged because they were sent as an RFC only. The
API towards the OS aren't clear (to me) yet, so it seems a bit
premature to build the user space API for that. But this RFC series
looks like a good start.
