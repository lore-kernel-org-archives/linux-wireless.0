Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sour.ops.eusc.inter.net ([84.23.254.154]:56505 "EHLO
	sour.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367AbZKXJLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 04:11:42 -0500
Message-ID: <4B0B9E99.1060201@snafu.de>
Date: Tue, 24 Nov 2009 09:51:37 +0100
From: Oncaphillis <oncaphillis@snafu.de>
Reply-To: oncaphillis@snafu.de
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH RFC] ssb: Generic SPROM override for devices without SPROM
References: <200911201212.19588.mb@bu3sch.de>
In-Reply-To: <200911201212.19588.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/2009 12:12 PM, Michael Buesch wrote:
> This patch adds a generic mechanism for overriding the SPROM mechanism
> on devices without SPROM hardware.
>
> There currently is a major problem with this:
> It tries to deduce a MAC address from various hardware parameters. But
> currently it will result in the same MAC address for machines of the same
> type. Does somebody have an idea of some device-instance specific serial
> number or something similar that could be hashed into the MAC?
>
What version is this patch against ? I tries rc7,rc8 and 2.6.31.6.
But it doesn't work for me.

Thank you

Sebastian

