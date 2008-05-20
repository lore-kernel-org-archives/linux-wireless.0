Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:23850 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633AbYETHye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 03:54:34 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: Fix ethtool statistics
Date: Tue, 20 May 2008 09:54:25 +0200
Cc: David Woodhouse <dwmw2@infradead.org>, linville@tuxdriver.com,
	Sebastian Siewior <liber+tas@ml.breakpoint.cc>,
	linux-wireless@vger.kernel.org
References: <1211211122.21380.167.camel@pmac.infradead.org>
In-Reply-To: <1211211122.21380.167.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805200954.25508.hs4233@mail.mn-solutions.de> (sfid-20080520_095436_998016_5E737639)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Acked for the CF card. Maybe I'll create a patch on top of this 
that gives me ethtool -s support for the ethX interface as well.
