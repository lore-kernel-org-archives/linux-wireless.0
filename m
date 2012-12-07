Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62763 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab2LGAxo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 19:53:44 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so35062lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 16:53:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-13-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-13-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 16:53:23 -0800
Message-ID: <CAB=NE6XUZf+KTwadoY3ezavJnejX9MYMCwCH97XD7+34jdUgoA@mail.gmail.com> (sfid-20121207_015349_185803_02C759D9)
Subject: Re: [PATCH 12/24] regulatory: simplify restore_regulatory_settings
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Use list_splice_tail_init() and also simplify the locking.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

Super sexy.

  Luis
