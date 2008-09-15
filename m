Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.233]:36939 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbYIOWNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 18:13:16 -0400
Received: by qb-out-0506.google.com with SMTP id f11so3799857qba.17
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 15:13:15 -0700 (PDT)
Message-ID: <415f2dc40809151513s12a26b9ch81a15a4493c737da@mail.gmail.com> (sfid-20080916_001320_657297_148D37BC)
Date: Mon, 15 Sep 2008 18:13:15 -0400
From: "Brian Prodoehl" <bprodoehl@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: userspace tools
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forgive me for such a n00b question, but what are the userspace tools
of choice for mac80211?  I'd like to extend some user space tool to
allow me to do things like set the tx and rx antenna for ath5k.
Something tells me that hacking iwconfig isn't the way to go.  I get
the reasons behind the move to cfg80211 and nl80211, but is there
anything useful for these yet?  I have yet to do anything useful with
iw, and I'm not finding any intended replacement for iwconfig.  I know
the move to cfg80211 and nl80211 is a work in progress, but it
definitely feels like I'm missing something.
