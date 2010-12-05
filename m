Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45766 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab0LEPW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Dec 2010 10:22:27 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1PPGPy-0006Po-GE
	for linux-wireless@vger.kernel.org; Sun, 05 Dec 2010 16:22:26 +0100
Subject: Re: Compat-wireless release for 2010-12-04 is baked
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20101204200249.298B040F97@repository3.orbit-lab.org>
References: <20101204200249.298B040F97@repository3.orbit-lab.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Dec 2010 16:22:25 +0100
Message-ID: <1291562545.3495.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-12-04 at 15:02 -0500, Compat-wireless cronjob account
wrote:

> scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap/Makefile: No such file or directory
> make[4]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap/Makefile'.  Stop.
> make[3]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap] Error 2
> make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless] Error 2
> make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
> make: *** [clean] Error 2

maybe the script can at least change the subject to "half-baked" when it
fails ;-)

johannes

