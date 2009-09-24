Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:40525 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZIXUIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 16:08:35 -0400
Received: by iwn8 with SMTP id 8so1203468iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 13:08:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <da94abde0909241214y8179cfeoa86aa59346daa9ef@mail.gmail.com>
References: <20090924180048.14503.9579.stgit@tikku> <20090924180242.14503.11148.stgit@tikku>
	<43e72e890909241132r2c684de2i9e80537bc3d13c63@mail.gmail.com>
	<da94abde0909241214y8179cfeoa86aa59346daa9ef@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 24 Sep 2009 13:08:19 -0700
Message-ID: <43e72e890909241308h47c36f40pe0149412ed5bb080@mail.gmail.com>
Subject: Re: [PATCH 1/2] cfg80211: add firmware and hardware version to wiphy
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 12:14 PM, Kalle Valo <kalle.valo@iki.fi> wrote:

> The length is used four time so I would not want to remove it. Maybe
> rename to CFG80211_FWHW_VERSION_LEN?

Sure.

  Luis
