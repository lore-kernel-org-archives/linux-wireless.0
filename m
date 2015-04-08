Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59988 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbDHD0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 23:26:06 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21796.40851.132919.363957@gargle.gargle.HOWL> (sfid-20150408_052612_853362_A958AEFE)
Date: Wed, 8 Apr 2015 08:55:07 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k to ath9k IBSS, ath9k has interface-combinations issue
In-Reply-To: <55241567.3010703@candelatech.com>
References: <5523273F.4060803@candelatech.com>
	<CA+BoTQ=UUbfi5D9ZbN5Rxb20f5xpzuYQMo392=P++Qyhz8Hs+w@mail.gmail.com>
	<CALhHN=oCvQ=SvobWTvc3geK-66k2+YDzB1HqSguCxTeV0QzWwg@mail.gmail.com>
	<552406E4.50600@candelatech.com>
	<55241567.3010703@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> For the third set, why limit to a single interface.  Can't we run IBSS + AP
> (and plus stations, for that matter), all at the same time with ath9k?

TSF would jump around since the HW would sync with the
received beacons and this will happen in both IBSS and station
mode. Hence the limitation, but I think OpenWrt has a one-liner
to remove this restriction...

Sujith
