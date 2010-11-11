Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61214 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0KKSTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 13:19:07 -0500
Received: by iwn10 with SMTP id 10so2456320iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 10:19:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <23232015.1011289487455461.JavaMail.wlan@CHBU500181>
References: <17888045.991289487433290.JavaMail.wlan@CHBU500181> <23232015.1011289487455461.JavaMail.wlan@CHBU500181>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Nov 2010 10:18:47 -0800
Message-ID: <AANLkTinpan-k4J2Z-gB3vcRMHKpwtg0-Ra42S9WuS9Rr@mail.gmail.com>
Subject: Re: [PATCH 1/9] ath5k: AHB port. Use generic DMA instead of PCI API.
To: Wojciech Dubowik <dubowoj@neratec.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 6:57 AM, Wojciech Dubowik <dubowoj@neratec.com> wrote:
> General comments for AHB bus support in ath5k:
>  - most of the original patches came from Felix Fetikau. I have used them as a reference and ported to current git tree
>  - tried with access point functionality with WPA2 and without encryption
>  - tested on AR5312 for AHB and AR5414 and AR5212 for PCI
>  - compat wireless from openwrt was used for testing these patches
>  - last two patches have to be applied together because otherwise hardware will crash on reset if
>  only number 9 is committed. I have kept them separated for better visibility
>
>
>
> Generic DMA is needed for AHB support.
>
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>

Nice! You want to send these patches in a series as you have but use a
cover letter to introduce and explain the series. This patch's commit
log should only note that this uses the Generic DMA APIs in order to
later support AHB. You can get yourself a cover letter using git
format-patch --cover-letter. For more elaborate examples check out:

http://wireless.kernel.org/en/developers/Documentation/git-guide

  Luis
