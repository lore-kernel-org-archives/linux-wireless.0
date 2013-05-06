Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:59952 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab3EFQG3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 12:06:29 -0400
Date: Mon, 6 May 2013 18:06:24 +0200
From: Jakub Kicinski <kubakici@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [RFC 12/14] rt2x00: rt61pci: implement
 queue_init callback
Message-ID: <20130506180624.07b47b86@north> (sfid-20130506_180636_795031_FD4E3EFB)
In-Reply-To: <1367497829-7672-13-git-send-email-juhosg@openwrt.org>
References: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
	<1367497829-7672-13-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu,  2 May 2013 14:30:27 +0200, Gabor Juhos wrote:
> The generic rt2x00 code has been changed to allow the
> drivers toimplement dynamic data_queue initialization.
>
> Remove the static data queue descriptor structures
> and implement the queue_init callback instead.
>
> Compile tested only.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Seems to work on rt61pci as well ;)

Feel free to remove "Compile tested only." and/or add:

Tested-by: Jakub Kicinski <kubakici@wp.pl>

  -- Kuba
