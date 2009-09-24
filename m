Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:45433 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZIXUUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 16:20:51 -0400
Received: by iwn8 with SMTP id 8so1210147iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 13:20:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090924180048.14503.9579.stgit@tikku>
References: <20090924180048.14503.9579.stgit@tikku>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 24 Sep 2009 13:20:35 -0700
Message-ID: <43e72e890909241320j592e347die8a14f8bdd962ffb@mail.gmail.com>
Subject: Re: [PATCH 0/2] cfg80211: firmware and hardware version
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 11:02 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Here's my suggestion how to provide firmware and hardware version to
> user space. First I was thinking adding a new nl80211 command and
> it looked so ugly that I decided include the versions in struct wiphy
> instead.
>
> Please comment.

What was the conclusion on ethtool stuff again? I forgot.

  Luis
