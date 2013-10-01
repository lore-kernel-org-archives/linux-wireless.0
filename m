Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:40458 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3JAWjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 18:39:36 -0400
Received: by mail-oa0-f50.google.com with SMTP id j1so3579oag.37
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 15:39:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380627023.14430.34.camel@jlt4.sipsolutions.net>
References: <1379115372-28426-1-git-send-email-yeohchunyeow@cozybit.com>
	<1379115372-28426-6-git-send-email-yeohchunyeow@cozybit.com>
	<1380627023.14430.34.camel@jlt4.sipsolutions.net>
Date: Wed, 2 Oct 2013 06:39:36 +0800
Message-ID: <CAHS2MGMHbcSONb6Ze9_=wUnBynAGayM+tmdC3OWS1jcYbOOSGA@mail.gmail.com> (sfid-20131002_003939_075316_47AE93F1)
Subject: Re: [PATCH 5/5] mac80211: process mesh channel switching using beacon
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	"distro11s@cozybit.com" <distro11s@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I think it'd be worth doing some refactoring here to have an output
> struct ... the parameters to this function are getting unreal. :)
Yes. Bob commented this before. I will take a look on this.

> Seems like you should *do* something here, like return false?
Yes. You are right.

-- Chun-Yeow
