Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:54700 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3JKQoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 12:44:05 -0400
Received: by mail-ob0-f175.google.com with SMTP id uz6so2942773obc.20
        for <linux-wireless@vger.kernel.org>; Fri, 11 Oct 2013 09:44:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381498511.14293.17.camel@jlt4.sipsolutions.net>
References: <1380760429-26100-1-git-send-email-yeohchunyeow@cozybit.com>
	<1380760429-26100-6-git-send-email-yeohchunyeow@cozybit.com>
	<1381498511.14293.17.camel@jlt4.sipsolutions.net>
Date: Fri, 11 Oct 2013 09:44:04 -0700
Message-ID: <CAHS2MGPNTS02O-iWDbVyoDyuBFte==fP_iTOvi-inr24bH3pUg@mail.gmail.com> (sfid-20131011_184410_648233_E6978FF1)
Subject: Re: [PATCH v3 5/6] {nl,cfg,mac}80211: finalizing mesh channel switching
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	"distro11s@cozybit.com" <distro11s@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This looks broken without kfree_rcu() or synchronize_rcu(), if it's OK
> then at least add a comment? I think it's not OK though.
Ok, we fix this soon.

---
Chun-Yeow
