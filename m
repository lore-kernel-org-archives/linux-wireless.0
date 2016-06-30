Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41586 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbcF3LMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 07:12:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: return false when reading wrong eeprom offset
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <5762DAC7.8090904@riverbed.com>
To: Eduardo Abinader <eduardo.abinader@riverbed.com>
CC: <ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Message-ID: <80b41e3205094547afa4be3927fc9409@euamsexm01a.eu.qualcomm.com> (sfid-20160630_131308_378726_8C460AA0)
Date: Thu, 30 Jun 2016 13:12:47 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eduardo Abinader <eduardo.abinader@riverbed.com> wrote:
> Just setting the proper return for reading beyond the eeprom data.
> 
> Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>
> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

0f27ac40fb64 ath9k: return false when reading wrong eeprom offset

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9181371/

