Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09571DFD8
	for <linux-wireless@vger.kernel.org>; Tue,  2 Jul 2024 11:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719920925; cv=none; b=mGnOZ/eFiEykuAktDRROJxv74MzGhBOvyakRnUwwWXlO40JwfDV6sI7pSww/0qdPnDKOYXe5Dh9UXs6ZtowIQsXnuBEDkKbIG3PLJuKvproz+7WiWHv0WDEJkSuHzaQe7jDrxKCB53nkBHNubj78UjxGJxkFQcGwSMDVeHNSajQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719920925; c=relaxed/simple;
	bh=m+C6X4pV0UkL2V3McROpb/Y5t/0KdnLo5PPIoQRHanc=;
	h=From:To:Subject:In-Reply-To:References:MIME-Version:Content-Type:
	 Message-ID:Date; b=O5pF2Truud88/bBXryASt9Z4EK49LdKzv7Oz90P8+Fkv2BivB/rXSaW0SEmq9heNid2ii3kPwR6N1J3zNjJ4+JXPrdkUINgcVfPTKkfQ8HXRpyzDCBnYeGmiX0o6wMA/NJkgHC7a6dVIUlfvDHGPDFY27xWaMS29wY+Uv8cTlSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
X-SpamFilter-By: ArmorX SpamTrap 5.78 with qID 462BmeuY7881385, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
	by rtits2.realtek.com.tw (8.15.2/3.02/5.92) with ESMTPS id 462BmeuY7881385
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Tue, 2 Jul 2024 19:48:40 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 2 Jul 2024 19:48:40 +0800
Received: from [127.0.1.1] (172.16.17.57) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Tue, 2 Jul
 2024 19:48:39 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] wifi: rtw89: 8852bt: rfk: add IQK
In-Reply-To: <20240627025849.25198-2-pkshih@realtek.com>
References: <20240627025849.25198-1-pkshih@realtek.com> <20240627025849.25198-2-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <d3f71cc3-4e35-45fc-b093-f5f8f27080fb@RTEXMBS04.realtek.com.tw>
Date: Tue, 2 Jul 2024 19:48:39 +0800
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)

Ping-Ke Shih <pkshih@realtek.com> wrote:

> IQ signal calibration is a very important calibration to yield good RF
> performance. We do this calibration once we are going to an AP. During
> scanning phase, without this calibration RF performance is still
> acceptable because it transmits and receives with low data rate at
> this phase.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

4 patch(es) applied to rtw-next branch of rtw.git, thanks.

f77c5179bc9f wifi: rtw89: 8852bt: rfk: add IQK
c3d9705de5e7 wifi: rtw89: 8852bt: rfk: add RX DCK
39f0123e0321 wifi: rtw89: 8852bt: rfk: add DACK
746f4ae52a38 wifi: rtw89: 8852bt: rfk: add RCK

---
https://github.com/pkshih/rtw.git

