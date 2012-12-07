Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:49814 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab2LGAjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 19:39:23 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so5748206lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 16:39:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-12-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-12-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 16:39:01 -0800
Message-ID: <CAB=NE6U5ejbsvynrBwAVVvH8eFeG3ez3bExqbOn-shOrhe4VYg@mail.gmail.com> (sfid-20121207_013927_362586_109718F7)
Subject: Re: [PATCH 11/24] regulatory: remove BUG_ON
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> This code is a bit too BUG_ON happy, remove all
> instances and while doing so make some code a bit
> smarter by passing the right pointer instead of
> indices into arrays.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis
