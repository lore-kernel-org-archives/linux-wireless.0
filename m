Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:58897 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752548AbXLLACF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 19:02:05 -0500
Date: Wed, 12 Dec 2007 00:58:07 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP][PATCH] rc80211_pid: Send events to userspace for
 debugging
Message-ID: <20071212005807.1538999f@morte> (sfid-20071212_000211_019734_761CC4EF)
In-Reply-To: <1197414686.7030.27.camel@localhost>
References: <1197414686.7030.27.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 12 Dec 2007 00:11:26 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> Hey,
> 
> this is the rc80211_pid event reporting patch that provides the data for
> the failed frames percentage and tx rate graphs. Instead of using
> syslog, I did it properly, so we can later decide whether we even want
> this in the tree. It's rather large, so I'm not to sure.

Good job! Well, we could split this in two files, one (called
rc80211_pid_debugfs.c e.g.) which would contain the debugfs-related
implementation, while the event calls would go in rc80211_pid.c. That way
inclusion sounds more feasible, even if overkill maybe.

> The script that feeds the data into gnuplot is attached. It currently
> generates only a single plot showing failed frames percentage and tx
> rate over time. Note that there is more data available in the
> information read from the kernel, I'll add other diagrams when the need
> for looking at them arises :-)

I'll make some graphs too in the next few days. ;) Heading to the microwave
oven...


--
Ciao
Stefano
