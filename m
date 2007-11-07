Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbXKGToc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 14:44:32 -0500
Subject: [PATCH] libertas: move to uniform lbs_/LBS_ namespace
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 14:41:33 -0500
Message-Id: <1194464493.4582.0.camel@localhost.localdomain> (sfid-20071107_194437_340137_9CA1AE8B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <hs4233@mail.mn-solutions.de>

This patch unifies the namespace of variables, functions defines
and structures. It does:

- rename libertas_XXX to lbs_XXX
- rename LIBERTAS_XXX to lbs_XXX
- rename wlan_XXX to lbs_XXX
- rename WLAN_XXX to LBS_XXX (but only those that were
  defined in libertas-local *.h files, e.g. not defines
  from net/ieee80211.h)

While passing, I fixed some checkpatch.pl errors too.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Acked-by: Dan Williams <dcbw@redhat.com>

Patch is quite large, available at the URL below.  I've updated the
patch and smoketested it, plus verified it does not change module
parameter names.

http://people.redhat.com/dcbw/libertas-namespace-cleanup.patch


