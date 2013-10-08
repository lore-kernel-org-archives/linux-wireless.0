Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:18638 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597Ab3JHKqE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 06:46:04 -0400
Date: Tue, 8 Oct 2013 12:47:28 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Kevin Lo <kevlo@kevlo.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2] rt2x00: rt2800lib: no need to toggle
 RF R30 bit 7 twice
Message-ID: <20131008104728.GB15764@localhost.localdomain> (sfid-20131008_124608_222139_A6F0F304)
References: <20131007080201.GA18265@ns.kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131007080201.GA18265@ns.kevlo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 07, 2013 at 04:02:01PM +0800, Kevin Lo wrote:
> In rt2800_config_channel_rf3xxx(), there's no need to toggle
> RF R30 bit 7 twice. 
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>

This one is fine.

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

