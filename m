Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:34607 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbZIXDz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 23:55:58 -0400
Received: by iwn8 with SMTP id 8so717148iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2009 20:56:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <da94abde0909231800v75b05677ka6b8570a73b6055c@mail.gmail.com>
References: <da94abde0909231800v75b05677ka6b8570a73b6055c@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 23 Sep 2009 20:55:42 -0700
Message-ID: <43e72e890909232055x781e4f3p977f9344453528fc@mail.gmail.com>
Subject: Re: wireless-testing broken
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 23, 2009 at 6:00 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Hi,
>
> I upgraded to latest wireless-testing and noticed that I can't connect
> anymore with my iwl3945. master-2009-09-16 still works. My syslog has
> this:

Hm, seems to work fine with my ath5k and ath9k device. So perhaps this
is just an iwl3945 regression?

  Luis
