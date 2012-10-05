Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:57393 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab2JEQpV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 12:45:21 -0400
Message-ID: <506F0A56.70900@01019freenet.de> (sfid-20121005_184524_575070_B687DE3C)
Date: Fri, 05 Oct 2012 18:27:02 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 1/7] rt2800: use BBP_R1 for setting tx
 power
References: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Stanislaw!

I would like to test this patchset. Whereon should I pay (most)
attention? What do you expect to be changed (or not) behaviour with 2.4
GHz / 40 MHz?


Thanks,
kind regards,
Andreas

Stanislaw Gruszka wrote:
> TX power delta can be negative. TX_PWR_CFG_ registers allow to set delta
> only in range between 0 dBm and 15 dBm (4 bits for each rate). Se we
> need to use BBP_R1 to configure negative deltas.
[...]

