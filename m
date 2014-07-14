Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:58073 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbaGNFuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 01:50:11 -0400
Date: Sun, 13 Jul 2014 22:50:09 -0700 (PDT)
Message-Id: <20140713.225009.396398583917314813.davem@davemloft.net> (sfid-20140714_075036_175700_C6D556F7)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next 2014-07-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140711200650.GL25478@tuxdriver.com>
References: <20140711200650.GL25478@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 11 Jul 2014 16:06:50 -0400

> Please pull this batch of updates intended for the 3.17 stream...
> 
> This is primarily a Bluetooth pull.  Gustavo says:
> 
> "A lot of patches to 3.17. The bulk of changes here are for LE support.
> The 6loWPAN over Bluetooth now has it own module, we also have support for
> background auto-connection and passive scanning, Bluetooth device address
> provisioning, support for reading Bluetooth clock values and LE connection
> parameters plus many many fixes."
> 
> The balance is just a pull of the wireless.git tree, to avoid some
> pending merge problems.
> 
> Please let me know if there are problems!

Pulled, thanks John.
