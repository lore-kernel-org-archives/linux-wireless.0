Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34711 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab2LMVma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 16:42:30 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so2229364lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 13:42:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-22-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-22-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 13:42:09 -0800
Message-ID: <CAB=NE6W2pYJvr9ea+D8nyTxeitQbf+QQu6EyXvaVCxUNP9VnMQ@mail.gmail.com> (sfid-20121213_224233_792606_F2D0E7FD)
Subject: Re: [PATCH 21/24] regulatory: pass new regdomain to reset function
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Instead of assigning after calling the function do
> it inside the function. This will later avoid a
> period of time where the pointer is NULL.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis
