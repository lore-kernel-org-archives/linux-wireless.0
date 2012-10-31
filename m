Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37358 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2JaWgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 18:36:31 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1004482eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2012 15:36:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351709571-23301-1-git-send-email-mcgrof@do-not-panic.com>
References: <1351709571-23301-1-git-send-email-mcgrof@do-not-panic.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 1 Nov 2012 09:36:09 +1100
Message-ID: <CAGRGNgXyyvpSfFqd+L6J166Lfu7yfWc8-zMwpTMxLzFY+Qs0nA@mail.gmail.com> (sfid-20121031_233643_194552_18E24E68)
Subject: Re: [PATCH] carl9170: kill MODULE_VERSION
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

On Thu, Nov 1, 2012 at 5:52 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>
> This is pretty pointless. Lets kill this to stop people from
> thinking that its actually used. Maybe we should go on
> a crusade and kill this completely from the kernel.

I'm sure that there are a multitude of places where MODULE_VERSION is
unnecessary, but killing it from the entire kernel simply won't
happen. I know that in the SCSI subsystem some of the
vendor-maintained drivers use this to keep track of exactly which
version is running on a given kernel. (Why not use kernel releases?
not sure, probably a combination of user-interface, distro backporting
and internal systems.)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
