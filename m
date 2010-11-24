Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33334 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab0KXQ7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 11:59:45 -0500
Date: Wed, 24 Nov 2010 11:46:31 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Wojciech Dubowik <dubowoj@neratec.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/9] ath5k: AHB port. Use generic DMA instead of PCI API.
Message-ID: <20101124164631.GC7435@tuxdriver.com>
References: <17888045.991289487433290.JavaMail.wlan@CHBU500181>
 <23232015.1011289487455461.JavaMail.wlan@CHBU500181>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <23232015.1011289487455461.JavaMail.wlan@CHBU500181>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 03:57:36PM +0100, Wojciech Dubowik wrote:
> General comments for AHB bus support in ath5k:
>  - most of the original patches came from Felix Fetikau. I have used them as a reference and ported to current git tree
>  - tried with access point functionality with WPA2 and without encryption
>  - tested on AR5312 for AHB and AR5414 and AR5212 for PCI
>  - compat wireless from openwrt was used for testing these patches
>  - last two patches have to be applied together because otherwise hardware will crash on reset if
>   only number 9 is committed. I have kept them separated for better visibility

Are we going to see a repost of this series?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
