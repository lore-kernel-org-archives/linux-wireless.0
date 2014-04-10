Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934795AbaDJLOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 07:14:37 -0400
Message-ID: <1397128450.4757.19.camel@jlt4.sipsolutions.net> (sfid-20140410_131446_393770_E3C1788F)
Subject: Re: [PATCH 1/5] wil6210: Convert to Kbuild
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Michal Marek <mmarek@suse.cz>, Joe Perches <joe@perches.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	netdev <netdev@vger.kernel.org>
Date: Thu, 10 Apr 2014 13:14:10 +0200
In-Reply-To: <1949326.Ead3K8R9Y2@lx-vladimir> (sfid-20140410_122336_448287_D92FCC12)
References: <1396946179-11677-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1397059601.14321.19.camel@joe-AO722> <534654D7.4080904@suse.cz>
	 <1949326.Ead3K8R9Y2@lx-vladimir> (sfid-20140410_122336_448287_D92FCC12)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-04-10 at 13:23 +0300, Vladimir Kondratiev wrote:

> Accordingly to this, would you say I should drop this patch and go with
> GNUmakefile + Makefile for internal development? I am pretty neutral with
> this, just need to know what is the proper way.

Or you could just use the backports project for that :)

johannes

