Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46992 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965661AbeEYKCG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 06:02:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/52] ath: Add regulatory mapping for Bahamas
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180301141902.24824-2-sven.eckelmann@openmesh.com>
References: <20180301141902.24824-2-sven.eckelmann@openmesh.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: linux-wireless@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Message-Id: <20180525100205.D614360C4F@smtp.codeaurora.org> (sfid-20180525_120344_489027_8C19E811)
Date: Fri, 25 May 2018 10:02:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> wrote:

> The country code is used by the ath to detect the ISO 3166-1 alpha-2 name
> and to select the correct conformance test limits (CTL) for a country. If
> the country isn't available and it is still programmed in the EEPROM then
> it will cause an error and stop the initialization with:
> 
>   Invalid EEPROM contents
> 
> The current CTL mappings for this country are:
> 
> * 2.4GHz: ETSI
> * 5GHz: FCC
> 
> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

35 patches applied to ath-next branch of ath.git, thanks.

699e2302c286 ath: Add regulatory mapping for Bahamas
9c790f2d234f ath: Add regulatory mapping for Bermuda
b840fa912308 ath: Add regulatory mapping for Kenya
a71c984bc4e5 ath: Add regulatory mapping for Mauritius
a0a6f2a916dc ath: Add regulatory mapping for Montenegro
a20f1338c5de ath: Add regulatory mapping for Nicaragua
67a956682472 ath: Add regulatory mapping for Paraguya
2a3169a54bb5 ath: Add regulatory mapping for Serbia
667ddac5745f ath: Add regulatory mapping for Tanzania
1ea3986ad2bc ath: Add regulatory mapping for Uganda
4f183687e3fa ath: Add regulatory mapping for APL2_FCCA
9ba8df0c52b3 ath: Add regulatory mapping for APL13_WORLD
45faf6e096da ath: Add regulatory mapping for ETSI8_WORLD
897fab6c5d90 ath: Add regulatory mapping for ETSI9_WORLD
01fb2994a98d ath: Add regulatory mapping for FCC3_ETSIC
fed8f5e83037 ath: Map Albania to ETSI1_WORLD
485daee92bde ath: Map Algeria to APL13_WORLD
8120cc0b215c ath: Map Australia to FCC3_WORLD
1507b32891c0 ath: Map Bangladesh to APL1_WORLD
37090d944705 ath: Map Brunei Darussalam to APL6_WORLD
fed60f81a2d0 ath: Map Bulgaria to ETSI1_WORLD
515e968624b2 ath: Map Colombia to FCC1_FCCA
0fa31a86998b ath: Map Czech to ETSI1_WORLD
143a9b9bd7ee ath: Map Honduras to FCC3_WORLD
62ba2b22d120 ath: Map Isreal to ETSI3_WORLD
64874ed2a73a ath: Map Macedonia to ETSI1_WORLD
823a64065adf ath: Map Malasia to FCC1_WORLD
9bfc2bb32e01 ath: Map New Zealand to FCC3_ETSIC
b5c11e474406 ath: Map Peru to APL1_WORLD
c454d4c25844 ath: Map Philippines to FCC3_WORLD
12f415566fb4 ath: Map Romania to ETSI1_WORLD
b7e015132d85 ath: Map Russia to ETSI8_WORLD
054e07788002 ath: Map Singapore to FCC3_WORLD
4e78075c4821 ath: Map Ukraine to ETSI9_WORLD
f1abff21acc5 ath: Map Zimbabwe to ETSI1_WORLD

-- 
https://patchwork.kernel.org/patch/10251529/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
