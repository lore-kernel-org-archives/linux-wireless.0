Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39359 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab2KHRqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 12:46:38 -0500
Received: by mail-lb0-f174.google.com with SMTP id n3so2379339lbo.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2012 09:46:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgXyyvpSfFqd+L6J166Lfu7yfWc8-zMwpTMxLzFY+Qs0nA@mail.gmail.com>
References: <1351709571-23301-1-git-send-email-mcgrof@do-not-panic.com> <CAGRGNgXyyvpSfFqd+L6J166Lfu7yfWc8-zMwpTMxLzFY+Qs0nA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 8 Nov 2012 18:46:16 +0100
Message-ID: <CAB=NE6XzDrTt1azuEdZTUkVgP0LeLB5Jynb6h_h5N-+_ArCGGQ@mail.gmail.com> (sfid-20121108_184652_054926_FBF6E2D1)
Subject: Re: [PATCH] carl9170: kill MODULE_VERSION
To: Julian Calaby <julian.calaby@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 31, 2012 at 11:36 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Luis,
>
> On Thu, Nov 1, 2012 at 5:52 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
>> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>>
>> This is pretty pointless. Lets kill this to stop people from
>> thinking that its actually used. Maybe we should go on
>> a crusade and kill this completely from the kernel.
>
> I'm sure that there are a multitude of places where MODULE_VERSION is
> unnecessary, but killing it from the entire kernel simply won't
> happen.

Easily, nope, hard yes.

> I know that in the SCSI subsystem some of the
> vendor-maintained drivers use this to keep track of exactly which
> version is running on a given kernel.

What's this "vendor-maintained" thing?

> (Why not use kernel releases? not sure, probably a combination of user-interface, distro backporting
> and internal systems.)

Exactly, I'm alluding there's better ways to do this and to reflect
provenance better, but also by prioritizing upstream development.

 Luis
