Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab2GaNFF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 09:05:05 -0400
Date: Tue, 31 Jul 2012 15:04:49 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Chen, Chien-Chia" <machen@suse.com>
Cc: users@rt2x00.serialmonkey.com, kevin.chou@mediatek.com,
	woody.hung@mediatek.com, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH v3] rt2x00 : fix rt3290 resuming failed.
Message-ID: <20120731130448.GA3606@redhat.com> (sfid-20120731_150511_642585_5889F6B9)
References: <1343739105-19091-1-git-send-email-machen@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1343739105-19091-1-git-send-email-machen@suse.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 31, 2012 at 08:51:45PM +0800, Chen, Chien-Chia wrote:
> +EXPORT_SYMBOL_GPL(rt2800_enable_wlan_rt3290);
Since you removed this function from rt2800pci_probe_hw(), there is no
need to export it. It even can be static now.

Stanislaw

