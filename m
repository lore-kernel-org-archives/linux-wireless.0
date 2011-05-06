Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:44922 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab1EFJBo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 05:01:44 -0400
Subject: Re: [PATCH] ssb: move ssb_commit_settings and export it
From: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
In-Reply-To: <1304635505-9824-1-git-send-email-zajec5@gmail.com>
References: <1304635505-9824-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 11:01:37 +0200
Message-ID: <1304672497.22936.4.camel@maggie> (sfid-20110506_110150_905342_593D5FF3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-06 at 00:45 +0200, Rafał Miłecki wrote: 
> +EXPORT_SYMBOL(ssb_commit_settings);

Don't add EXPORT_SYMBOLs, unless you also add an actual
user within the same patch series.

-- 
Greetings Michael.

