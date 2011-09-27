Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab1I0IzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 04:55:07 -0400
Subject: Re: [PATCH 1/1] rfkill: add module option to become inactive.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Andrew V. Stepanov" <stanv@altlinux.org>
Cc: davem@davemloft.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAN8FffqjeurgAvVHtMExgeAyBHRWznYBz2c043jcZgOmqw6TVg@mail.gmail.com> (sfid-20110927_104704_588084_6AA6C25B)
References: <1317119624-2974-1-git-send-email-stanv@altlinux.org>
	 <1317109617.4082.0.camel@jlt3.sipsolutions.net>
	 <CAN8FffqH=x+qWnz=YJzatbW-b3aOgoivazH6Nb5SpsGt4Q6hGg@mail.gmail.com>
	 <1317110884.4082.5.camel@jlt3.sipsolutions.net>
	 <CAN8FffqjeurgAvVHtMExgeAyBHRWznYBz2c043jcZgOmqw6TVg@mail.gmail.com>
	 (sfid-20110927_104704_588084_6AA6C25B)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 10:54:59 +0200
Message-ID: <1317113699.4082.7.camel@jlt3.sipsolutions.net> (sfid-20110927_105511_657524_7D63D880)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-27 at 12:46 +0400, Andrew V. Stepanov wrote:

> I wan't to completely ignore events (state) of software\hardware rfkill buttons.

Why would you ever want to do that? I can see that you might want to
ignore soft buttons, but you can use urfkilld for that. Ignoring hard
buttons is completely useless -- they will affect the device they're
wired up to *anyway*.

johannes

