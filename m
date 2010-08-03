Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55252 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180Ab0HCQqS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Aug 2010 12:46:18 -0400
Received: from [192.168.0.22] (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by smtprelay1.cesmail.net (Postfix) with ESMTPSA id C8A3234C69
	for <linux-wireless@vger.kernel.org>; Tue,  3 Aug 2010 12:46:12 -0400 (EDT)
Subject: Re: Compat-wireless release for 2010-07-31 is baked
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20100731190245.76295404FA@repository3.orbit-lab.org>
References: <20100731190245.76295404FA@repository3.orbit-lab.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 12:46:07 -0400
Message-ID: <1280853967.26054.2.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-07-31 at 15:02 -0400, Compat-wireless cronjob account
wrote:
> compat-wireless code metrics
...
> Base tree: linux-next.git
> Base tree version: next-20100730
> compat-wireless release: compat-wireless-2010-07-13-4-g04898a5

Can we have the version based on 2.6.35 please?  Even if it's the same
as 2.6.35-rc6, the release based compat-wireless would be more readily
adopted.

Linux 2.6.35 adds ath9k_htc among other things.  Ubuntu 10.04 provides
compat-wireless based on 2.6.34 now.  Ububtu users keep asking about
ath9k_htc.  Let's make them happy :)

-- 
Regards,
Pavel Roskin
