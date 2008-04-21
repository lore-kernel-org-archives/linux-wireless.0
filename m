Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:41608 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbYDUQOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 12:14:04 -0400
Date: Mon, 21 Apr 2008 12:03:18 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: iwl4965: slow scans
Message-ID: <20080421160318.GA19802@phobos.i.cabal.ca> (sfid-20080421_181456_168258_46FC3BF0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I've noticed recently in rawhide that scanning for networks when I come
back from suspend takes an age. It seems to be upwards of 3~4 minutes
before I'm able to reassociate with my ap.

I'm pulling a pile of rpms to figure out when the change to
linux-2.6-wireless*.patch might have caused this (it doesn't *seem* to
happen on upstream, but since the patch might make it to upstream soon,
I figured I should keep linux-wireless@ in the loop.)

Willing to bash on whatever I need to to improve this.

cheers, Kyle
