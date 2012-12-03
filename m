Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:56444 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2LCPrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 10:47:37 -0500
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: help: 802.11s bad performance with 802.11n enabled
Date: Mon, 3 Dec 2012 15:47:33 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C125DB@RockMX01.rock.corp> (sfid-20121203_164740_856738_E9943F9D)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp>
 <alpine.DEB.2.02.1212031842350.27546@icf.org.ru>
 <BD54DDEB2546894FAB0731EA7B0EDF8D07C1259A@RockMX01.rock.corp>
 <alpine.DEB.2.02.1212031938250.7349@icf.org.ru>
In-Reply-To: <alpine.DEB.2.02.1212031938250.7349@icf.org.ru>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>On first look in my case disabled aggregation reduces packet loss, link is more reliable, but it's also drop throughput to 15-20 Mbits/sec from about ~50 with aggregation enabled.

Yes. This is the penalty of disabling aggregation. It's just a way to narrow down where is the problem.

Can any expert on 802.11n aggregation and/or 802.11s tell what's going on ?
