Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32917 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab2FYBA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2012 21:00:58 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20455.47109.203396.141311@gargle.gargle.HOWL> (sfid-20120625_030110_856298_39693A50)
Date: Mon, 25 Jun 2012 06:29:49 +0530
To: Guido Iribarren <guidoiribarren@buenosaireslibre.org>
CC: <ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Subject: Regression on ath9k_htc managed mode
In-Reply-To: <CAHD-aq+nNs4L0iZNxYSABX-1Wk+B=s-Avqc1TFYfO-8JOOZ5kA@mail.gmail.com>
References: <CAHD-aq+nNs4L0iZNxYSABX-1Wk+B=s-Avqc1TFYfO-8JOOZ5kA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guido Iribarren wrote:
> Hello nice people,
> we've recently found a bug when using infrastructure mode with tplink
> wn722n usb dongles (ath9k_htc driver)

Can you try this patch : http://tinyurl.com/7ywqzoz ?

Sujith
