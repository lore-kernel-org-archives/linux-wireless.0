Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:56947 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbXINAyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2007 20:54:16 -0400
Received: by py-out-1112.google.com with SMTP id u77so1446188pyb
        for <linux-wireless@vger.kernel.org>; Thu, 13 Sep 2007 17:54:15 -0700 (PDT)
Message-ID: <43e72e890709131754q62d803d2k30fcc83ef16e7bb2@mail.gmail.com>
Date: Thu, 13 Sep 2007 20:54:14 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH 2/3] Remove use of Atheros-specific modes from iwlwifi
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <1189730363.18944.24.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890709131703p1260f31fx2a20ea45742583ae@mail.gmail.com>
	 <1189730363.18944.24.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/13/07, Zhu Yi <yi.zhu@intel.com> wrote:
> On Thu, 2007-09-13 at 20:03 -0400, Luis R. Rodriguez wrote:
> > This patch removes usage of all Atheros turbo modes from iwlwifi.
> >
> > This patch is intended for the iwlwifi branch of wireless-dev after a
> > pull from origin/everything once
> > 01-remove-atheros-turbo-from-mac80211.diff is applied.
>
> The atheros turbo mode code is already removed from my latest update for
> iwlwifi. See my post yesterday with subject:
>
> "[PATCH wireless-dev#iwlwifi] update iwlwifi drivers to 0.1.15"

John, then this specific patch can be ignored.

  Luis
