Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:41903 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaBVA2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 19:28:24 -0500
Received: by mail-la0-f52.google.com with SMTP id c6so2902214lan.25
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 16:28:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392896671-4288-5-git-send-email-ilan.peer@intel.com>
References: <1392896671-4288-1-git-send-email-ilan.peer@intel.com> <1392896671-4288-5-git-send-email-ilan.peer@intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 21 Feb 2014 16:28:01 -0800
Message-ID: <CAB=NE6X4YbNcOonHqPiR7L_ZcQgVz2a=Y3KLA9aogJN0p3fiKw@mail.gmail.com> (sfid-20140222_012828_582767_28C26BB6)
Subject: Re: [PATCH 4/5] cfg80211: Add an option to hint indoor operation
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 20, 2014 at 3:44 AM, Ilan Peer <ilan.peer@intel.com> wrote:
> + * Note: currently not protected by any synchronization primitive.

You should verify this is protected by RTNL as the other stuff.

  Luis
