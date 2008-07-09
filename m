Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:56954 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYGINVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 09:21:23 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: fix memory alignment problems on the blackfin
Date: Wed, 9 Jul 2008 15:21:04 +0200
Cc: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>,
	linux-wireless@vger.kernel.org
References: <20080709031850.2e7bf50f@promwad.com>
In-Reply-To: <20080709031850.2e7bf50f@promwad.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807091521.04520.hs4233@mail.mn-solutions.de> (sfid-20080709_152126_670371_C783994E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Fixing unaligned memory access on the blackfin architecture
> (maybe on the ARM also).

You can delete the "maybe", on ARM (more specificially, on a 
PXA255, which is ARMv5TE) I didn't had a problem.
