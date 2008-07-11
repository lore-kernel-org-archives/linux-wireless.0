Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:36057 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbYGKVax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2008 17:30:53 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2398522waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2008 14:30:52 -0700 (PDT)
Message-ID: <b6c5339f0807111430w46b8a318yb35d787e084205b5@mail.gmail.com> (sfid-20080711_233057_535898_3989A289)
Date: Fri, 11 Jul 2008 17:30:52 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Chris Calitz" <chris@sabest.co.za>
Subject: Re: Compilation Problem
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1215680282.6376.5.camel@chris-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215680282.6376.5.camel@chris-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 10, 2008 at 4:58 AM, Chris Calitz <chris@sabest.co.za> wrote:
> Hi Everyone

Hi!

> I have found that the compact-wireless driver apparently fixes this
> issue but when I try to build this driver I get the following errors.

> /home/chris/wireless/compat-wireless-2008-07-10/drivers/net/wireless/mac80211_hwsim.c: In function 'init_mac80211_hwsim':

For now you can just turn off building mac80211_hwsim; it's a test driver so
you don't need it, and I don't think it is fully back-ported.  Edit config.mk
and set CONFIG_MAC80211_HWSIM=n.

-- 
Bob Copeland %% www.bobcopeland.com
