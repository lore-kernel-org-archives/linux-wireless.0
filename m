Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44507 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab0KLS4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 13:56:46 -0500
Received: by qwi2 with SMTP id 2so80722qwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 10:56:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinpan-k4J2Z-gB3vcRMHKpwtg0-Ra42S9WuS9Rr@mail.gmail.com>
References: <17888045.991289487433290.JavaMail.wlan@CHBU500181>
	<23232015.1011289487455461.JavaMail.wlan@CHBU500181>
	<AANLkTinpan-k4J2Z-gB3vcRMHKpwtg0-Ra42S9WuS9Rr@mail.gmail.com>
Date: Fri, 12 Nov 2010 13:56:45 -0500
Message-ID: <AANLkTi=5yGbbiu+U_=4cKcD3FVhOUY=u9CqFF=J_bRSo@mail.gmail.com>
Subject: Re: [PATCH 1/9] ath5k: AHB port. Use generic DMA instead of PCI API.
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Wojciech Dubowik <dubowoj@neratec.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 1:18 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Nov 11, 2010 at 6:57 AM, Wojciech Dubowik <dubowoj@neratec.com> wrote:
>> General comments for AHB bus support in ath5k:
>>  - most of the original patches came from Felix Fetikau. I have used them as a reference and ported to current git tree
>>  - tried with access point functionality with WPA2 and without encryption
>>  - tested on AR5312 for AHB and AR5414 and AR5212 for PCI
>>  - compat wireless from openwrt was used for testing these patches
>>  - last two patches have to be applied together because otherwise hardware will crash on reset if
>>  only number 9 is committed. I have kept them separated for better visibility
>
> Nice! You want to send these patches in a series as you have but use a
> cover letter to introduce and explain the series.

akpm would disagree :)

> This patch's commit
> log should only note that this uses the Generic DMA APIs in order to
> later support AHB. You can get yourself a cover letter using git
> format-patch --cover-letter. For more elaborate examples check out:

ACK, the comments at the top should be in a cover letter or after
the "---", or rewritten to be worth storing in the kernel history.

Could you also cc ath5k-devel@lists.ath5k.org?

Thanks for doing this work!

-- 
Bob Copeland %% www.bobcopeland.com
