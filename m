Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.blisses.org ([208.82.98.17]:39277 "EHLO mail.blisses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbXKZF6u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 00:58:50 -0500
Date: Sun, 25 Nov 2007 23:39:43 -0600
From: Matt Herzog <msh@blisses.org>
To: linux-wireless@vger.kernel.org
Subject: git guide page
Message-ID: <20071126053943.GD6034@chicago.blisses.org> (sfid-20071126_055858_160561_A8ADB283)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://linuxwireless.org/en/developers/git-guide#Getthelatestupdates

So. This page is not helpful at all :(

Specifically, the below syntax fails utterly.

cd /usr/src/wireless-2.6
git-checkout --track -b everything origin/everything
Usage: /usr/bin/git-checkout [-f] [-b <new_branch>] [-m] [<branch>] [<paths>...]

The syntax fails so badly I'm left wondering if it ever was tested.

What's up with that?

-- 
Monkeys are superior to men in this:
when a monkey looks into a mirror, he sees a monkey.

-- Malcolm De Chazal
