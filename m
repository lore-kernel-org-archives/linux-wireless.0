Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:63649 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbZCWXK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 19:10:26 -0400
Received: by yx-out-2324.google.com with SMTP id 31so2325662yxl.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 16:10:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237849455.16745.41.camel@marvin>
References: <1237849455.16745.41.camel@marvin>
Date: Mon, 23 Mar 2009 16:10:08 -0700
Message-ID: <43e72e890903231610k54ba0f15hf1e3146290c7d67a@mail.gmail.com> (sfid-20090324_001029_733150_B5308740)
Subject: Re: [BUG] rtl8187, cfg80211 - unable to handle kernel NULL pointer
	dereference
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Martin Capitanio <martin@capitanio.org>
Cc: Larry.Finger@lwfinger.net, herton@mandriva.com.br,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2009 at 4:04 PM, Martin Capitanio <martin@capitanio.org> wrote:
> Setting the EU or DE regulatory domain (cfg80211 ieee80211_regdom=EU)
> seems to be working, but afterwards inserting the rtl8187 driver causes crash:

Please try with today's wireless-testing a set of fixes went in to
address a bug with "EU". Mind you, "EU" is an invalid ISO3166-alpha2
so you may want to consider start using your own valid country alpha2
code. If you use "EU" now you'll world roam.

  Luis
