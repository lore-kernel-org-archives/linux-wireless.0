Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:43150 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaAXXcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 18:32:14 -0500
Received: by mail-la0-f42.google.com with SMTP id hr13so3096360lab.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 15:32:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 24 Jan 2014 15:31:52 -0800
Message-ID: <CAB=NE6U9At50W8oe-gBEPUmCMckRPLAoxv0KwzUbsg=jAiziqg@mail.gmail.com> (sfid-20140125_003219_254153_25750822)
Subject: Re: [RFC 0/5] Implement DFS CAC time as regulatory param
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 14, 2014 at 9:29 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Implement DFS CAC time inside regulatory.
> Currently tested with internal regdb.
>
> Changed way we check rule is correct in first patch - check
> more rules if they are continous.
> Added parsing DFS CAC to genregdb.awk script.
> Last patch is only an example I tested for PL regd.
> Implemented also iw patches for iw get regd/iw list
>
> CRDA/wireless-regdb - this is still missing.
> Please review.

During review I had the questions as Johannes did. Otherwise looks
good like the right approach. Be sure to also submit as part of your
series the respective CRDA and wireless-regdb changes.

  Luis
