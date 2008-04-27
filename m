Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:58495 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbYD0REf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 13:04:35 -0400
Received: from peterson.fenrir.org.uk ([10.0.0.2])
	(TLSv1:AES256-SHA:256)
	by mx.fenrir.org.uk with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1JqAIk-0000za-P8
	for <linux-wireless@vger.kernel.org>; Sun, 27 Apr 2008 18:04:34 +0100
Date: Sun, 27 Apr 2008 18:04:34 +0100
From: Brian Morrison <bdm@fenrir.org.uk>
To: linux-wireless@vger.kernel.org
Subject: Re: [REGRESSION] Trouble seeing some wireless networks in latest
 git
Message-ID: <20080427180434.2087eb15@peterson.fenrir.org.uk> (sfid-20080427_190446_263001_FD313F75)
In-Reply-To: <1209315625.4095.4.camel@localhost>
References: <1209288298.3851.12.camel@localhost>
	<48149F2B.4000503@lwfinger.net>
	<200804271748.49377.mb@bu3sch.de>
	<1209315625.4095.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 27 Apr 2008 20:00:25 +0300
Priit Laes <plaes@plaes.org> wrote:

> Where can I set the regdomain? I couldn't find any information under
> Documentation and with modinfo?

In /etc/modprobe.conf or equivalent, add:

options cfg80211 ieee80211_regdom="US" or "JP"

Currently these are the only two regulatory domains available.

-- 

Brian Morrison

   "Arguing with an engineer is like wrestling with a pig in the mud;
    after a while you realize you are muddy and the pig is enjoying it."
