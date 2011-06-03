Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab1FCNfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 09:35:38 -0400
Subject: Re: [PATCH 1/6] NFC: add nfc subsystem core
From: Johannes Berg <johannes@sipsolutions.net>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, marcio.macedo@openbossa.org,
	aloisio.almeida@openbossa.org, sameo@linux.intel.com,
	Waldemar.Rymarkiewicz@tieto.com
In-Reply-To: <1307051170-17374-2-git-send-email-lauro.venancio@openbossa.org> (sfid-20110602_234806_226419_B7FA629E)
References: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
	 <1307051170-17374-2-git-send-email-lauro.venancio@openbossa.org>
	 (sfid-20110602_234806_226419_B7FA629E)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 15:35:34 +0200
Message-ID: <1307108134.3800.1.camel@jlt3.sipsolutions.net> (sfid-20110603_153541_923050_E87AB535)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-02 at 18:46 -0300, Lauro Ramos Venancio wrote:

> +struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
> +					u32 supported_protocols);

Where do the protocols come from? I don't see any defines for them?

johannes

