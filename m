Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40055 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3FEHqY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 03:46:24 -0400
Message-ID: <1370418378.8920.12.camel@jlt4.sipsolutions.net> (sfid-20130605_094627_162843_35338AFA)
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: qca_vkondrat <qca_vkondrat@qca.qualcomm.com>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>
Date: Wed, 05 Jun 2013 09:46:18 +0200
In-Reply-To: <8887AA04B7EC49479420AE48C5F94A930EF6C0AA@NASANEXD02D.na.qualcomm.com>
References: <8887AA04B7EC49479420AE48C5F94A930EF6C0AA@NASANEXD02D.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-04 at 14:35 +0000, Malinen, Jouni wrote:

> In general, I'd agree. However, I would like to get information of any
> peer device being in active PBC mode. This would require either getting
> those Probe Request frames

I think I like that alternative better :-)

I know I wouldn't find it quickly ... can you be more specific about
what "being in active PBC mode" means? Is that easily detectable?

I'm thinking we should just document this (and be as specific about it
as we can) in the documentation for the offload feature.

johannes

