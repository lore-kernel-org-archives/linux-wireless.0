Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34857 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab0GSEfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 00:35:50 -0400
Received: by qwh6 with SMTP id 6so1551958qwh.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jul 2010 21:35:49 -0700 (PDT)
MIME-Version: 1.0
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Mon, 19 Jul 2010 14:35:28 +1000
Message-ID: <AANLkTilmifjH5Zopo82LhjidzsYfT_xRgKJzjGCZZPlq@mail.gmail.com>
Subject: ath5k Ad Hoc Association
To: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to get my wireless nodes to associate in ad hoc mode. They
were able to work correctly with madwifi-ng, but with ath5k, they
simply will not associate. I've tried monitoring the interface for any
frames being sent out, but no beacons appear to be going out. I'm
currently running Ubuntu 10.04 with the following kernel:
 2.6.32-23-generic-pae

I've built and installed the compat package for this kernel version:
compat-wireless-2.6.32.16

Any help with this would be greatly appreciated, or at least some
points to assist me in troubleshooting this issue.

Many thanks,

--
Jonathan
