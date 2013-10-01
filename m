Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:37301 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3JAWjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 18:39:02 -0400
Received: by mail-oa0-f43.google.com with SMTP id f4so8500oah.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 15:39:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380626731.14430.29.camel@jlt4.sipsolutions.net>
References: <1379115372-28426-1-git-send-email-yeohchunyeow@cozybit.com>
	<1379115372-28426-4-git-send-email-yeohchunyeow@cozybit.com>
	<1380626731.14430.29.camel@jlt4.sipsolutions.net>
Date: Wed, 2 Oct 2013 06:39:01 +0800
Message-ID: <CAHS2MGNToRrmrH5qoyd9442ne5=S7GR-eRmEcDB9YROQzG1ycg@mail.gmail.com> (sfid-20131002_003905_657645_1657282E)
Subject: Re: [PATCH 3/5] mac80211: adding the CSA and MCSP elements in mesh beaconing
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	"distro11s@cozybit.com" <distro11s@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Should this patch be before the other one so userspace can't trigger an
> invalid CSA thing inbetween the two patches?
Nope, this is related to add the new CSA IE elements to beacon. With
the first two patches, the userspace is already able to generate a
valid CSA action frame to trigger channel switch attempt on the mesh
network.

> Why is that csa_settings access not racy?
I will take a look on this.

--- Chun-Yeow
