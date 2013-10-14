Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:35136 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab3JNRP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 13:15:27 -0400
Received: by mail-ob0-f182.google.com with SMTP id wn1so5027197obc.13
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 10:15:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381760087.13092.12.camel@jlt4.sipsolutions.net>
References: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
	<1381516190-23918-3-git-send-email-yeohchunyeow@cozybit.com>
	<1381760087.13092.12.camel@jlt4.sipsolutions.net>
Date: Tue, 15 Oct 2013 01:15:26 +0800
Message-ID: <CAHS2MGPputyK+iF-bEXrozYAgbzv7bjFqxCUA3cSb3MQ77WEbQ@mail.gmail.com> (sfid-20131014_191530_089186_72BF26EE)
Subject: Re: [PATCH v4 2/6] {nl,cfg,mac}80211: enable the triggering of CSA
 frame in mesh
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	"distro11s@cozybit.com" <distro11s@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> How will userspace know whether or not this is supported? Will it just
> try and fail? Does it really not need to know?
The userspace will only try and fail at the time being. If it is
failed, the initiator will still remain at the current operating
channel.

---
Chun-Yeow
