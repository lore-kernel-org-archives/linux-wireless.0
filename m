Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:27442 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbYCMJM2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 05:12:28 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: convert GET_LOG to a direct command
Date: Thu, 13 Mar 2008 10:09:34 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200803130948.36528.hs4233@mail.mn-solutions.de> <200803130949.48715.hs4233@mail.mn-solutions.de>
In-Reply-To: <200803130949.48715.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Message-Id: <200803131009.34790.hs4233@mail.mn-solutions.de> (sfid-20080313_091238_555207_F01F76FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +	lbs_deb_enter_args(LBS_DEB_CMD,
> "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); +

Uh, I had a debug-statement there. Self-nacking my patch.
