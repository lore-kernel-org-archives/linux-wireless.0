Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45317 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZFOMPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 08:15:32 -0400
Date: Mon, 15 Jun 2009 08:04:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: rfkill regression in net-next-2.6
Message-ID: <20090615120422.GA2729@tuxdriver.com>
References: <20090604152011.GC2839@tuxdriver.com> <20090607.033751.191866033.davem@davemloft.net> <4A2BCC41.1060508@hartkopp.net> <20090607145830.GA2736@tuxdriver.com> <4A2BD8A5.4040302@hartkopp.net> <1244388583.23850.87.camel@localhost.localdomain> <4A34BAB9.9000104@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A34BAB9.9000104@hartkopp.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 14, 2009 at 10:54:17AM +0200, Oliver Hartkopp wrote:

> Any idea what changed in net-next-2.6 that could produce this behaviour?

The rfkill subsystem rewrite would seem suspect... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
