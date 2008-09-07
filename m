Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:52194 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbYIGBI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 21:08:26 -0400
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Sun, 07 Sep 2008 03:08:44 +0200
Message-Id: <1220749724.6714.128.camel@californication> (sfid-20080907_030843_528482_D2A23C81)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> This series should fix mac problems in disassociation
> There are two basic problems disassociation in current implementation.
> The order of steps in the dissociation flow and missing proper
> disassociation when moving from one AP to another. 

it would be nice if you add the problem description into the commit
messages of the actual patches. This helps to actually figure out the
reason for these kind of changes and they are then stored together with
the patch. We really have to be more verbose why we are doing things. If
anyone has to go through one year old kernels and figure out why a
change has been made, they are basically lost. I had to go through 7
years old kernels in the past and every extra piece of information is so
useful then.

Regards

Marcel


