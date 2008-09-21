Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:41331 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYIUWmX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 18:42:23 -0400
Date: Sun, 21 Sep 2008 23:42:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	reinette.chatre@intel.com, jgarzik@pobox.com,
	linville@tuxdriver.com, davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080921224210.GA24461@srcf.ucam.org>
References: <20080921172316.GA6306@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080921172316.GA6306@2ka.mipt.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Try D3ing the chip in the firmware restart code. Yes, it's retarded.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
