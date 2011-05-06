Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52208 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab1EFQfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 12:35:31 -0400
Received: by ywj3 with SMTP id 3so1236040ywj.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 09:35:30 -0700 (PDT)
Date: Fri, 6 May 2011 12:35:26 -0400
From: Tom Horsley <horsley1953@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: r8192cu AP mode?
Message-ID: <20110506123526.53b75672@tomh> (sfid-20110506_183533_365166_683CE45E)
In-Reply-To: <4DC40CEB.5010107@lwfinger.net>
References: <20110506081356.08ac93a8@tomh>
	<4DC40CEB.5010107@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 06 May 2011 09:59:55 -0500
Larry Finger wrote:

> If not, you can always get the compat-wireless 
> sources from http://wireless.kernel.org/en/users/Download.

Well, the mac80211 code won't compile with the fedora
2.6.35 kernel headers because there isn't a kfree_rcu
that far back in time, so I probably need to see about
either updating the kernel or back porting some kind
of kfree_rcu hack just for the mac80211 driver build.
