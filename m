Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.236]:59779 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbXKODhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 22:37:20 -0500
Received: by nz-out-0506.google.com with SMTP id s18so391727nze
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2007 19:37:19 -0800 (PST)
Message-ID: <1197ff4c0711141937gc7bb1f8w499cd9d8634fa232@mail.gmail.com> (sfid-20071115_033727_558011_30954D13)
Date: Thu, 15 Nov 2007 11:37:18 +0800
From: "Li YanBo" <dreamfly281@gmail.com>
To: "Ben Gamari" <ben@mw0.ath.cx>
Subject: Re: Suspend/Resume support
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1195087905.3814.11.camel@mercury>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1195087905.3814.11.camel@mercury>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 15, 2007 8:51 AM, Ben Gamari <ben@mw0.ath.cx> wrote:
> Hi all,
>
> Some time ago there was discussion on this list regarding suspend/resume
> support in mac80211 (See 05 Aug 2007, "suspend/resume support in
> mac80211"). The conclusion of this thread was that mac80211 had no
> suspend/resume support and that functionality to stop the stack needed
> to be added to fully support suspend. Has anyone started working on
> implementing this functionality?
>
> If not, precisely what needs to be done to add robust suspend/resume
> support to mac80211? Might this be a project that someone not presently
> familiar with the mac80211 codebase could tackle with some guidance?
> Thanks a ton,
>

Hope below link is helpful:
http://kernelnewbies.org/KernelProjects/Mac80211Suspend

Li YanBo
