Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:50476 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbYLNILh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2008 03:11:37 -0500
Received: by ti-out-0910.google.com with SMTP id b6so1397948tic.23
        for <linux-wireless@vger.kernel.org>; Sun, 14 Dec 2008 00:11:35 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18756.48950.20615.440764@localhost.localdomain> (sfid-20081214_091157_739703_E23ACFCC)
Date: Sun, 14 Dec 2008 13:39:26 +0530
To: "Jaswinder Singh" <jaswinderlinux@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	lrodriguez@atheros.com, jmalinen@atheros.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: BUG - ath9k keep on disconnecting in 2.6.28-rc8
In-Reply-To: <3f9a31f40812132354k6f9e7b80o30d3236687dffba0@mail.gmail.com>
References: <3f9a31f40812132354k6f9e7b80o30d3236687dffba0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jaswinder Singh wrote:
> I am facing problem with 2.6.28-rc8, ath9k keep on disconnecting.

[...]

> wlan0: authenticate with AP 00:11:95:9e:df:f6
> ForceXPAon: 0
> wlan0: authenticate with AP 00:11:95:9e:df:f6
> wlan0: authenticate with AP 00:11:95:9e:df:f6
> wlan0: authenticate with AP 00:11:95:9e:df:f6
> wlan0: authentication with AP 00:11:95:9e:df:f6 timed out

A number of updates have gone into the wireless-testing tree.
You can use that tree or compat-wireless to get the latest driver
and check if the problem persists.

Sujith
