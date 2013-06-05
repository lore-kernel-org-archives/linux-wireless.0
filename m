Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28805 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab3FEIM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 04:12:59 -0400
Date: Wed, 5 Jun 2013 11:12:53 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: qca_vkondrat <qca_vkondrat@qca.qualcomm.com>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
Message-ID: <20130605081253.GA4289@jouni.qca.qualcomm.com> (sfid-20130605_101322_092088_B545111C)
References: <8887AA04B7EC49479420AE48C5F94A930EF6C0AA@NASANEXD02D.na.qualcomm.com>
 <1370418378.8920.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1370418378.8920.12.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 05, 2013 at 09:46:18AM +0200, Johannes Berg wrote:
> I know I wouldn't find it quickly ... can you be more specific about
> what "being in active PBC mode" means? Is that easily detectable?

Having Device Password ID attribute in the WSC element set to 4
(PushButton) in Probe Request frames (or Probe Response and Beacon
frames in case of AP/GO).

-- 
Jouni Malinen                                            PGP id EFC895FA
