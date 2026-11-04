Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793824269;
	b=0Kq1LesNJFZzXFxtlBppb7I9VxDH7hUFYABNogSGZv82/Z9Pv71C/vjAR8XqF/E+eem3
	 FW6XjOfK7NeT5PCVWsAZfgMu4iHFSrMmJFwrmoOSbDxCEbipOKjwkMEzqEBYBsy7Pc8nB
	 r4bUaCkRsPABQKE8vk0WiI9joKGbj97aZMBxRNIRIt6oupytMDnTZG3A7EKA+55vExZ/Y
	 0JoF6mf9mmvPOr6U/rHfWdulnyHvc2In2IknpS86FWNHkWKwA0/KuxS2cjeKURDmHL8xA
	 TdRYrxm3Ey7/TnLXTEc/IX5mCXST60duWusGCF1ESbdGxBfidBVhPSbYNirCZQ1nOeQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793824269;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-ZohoMailClient;
	bh=U4L4/KbrFieS+0UXgWqlk7B9bXIXbAaNfkWea0yLlQ8=;
	b=wAaXD7osfHnD9L4UQRpbIf5eUZx28sisfPlfnUg3cIoFwO6cEWEaAasrGHN73khYXyGP
	 dNru62KvrYuXqxHYF2aej1Lw0rkxTr/ga1lhtdFcr6Z1+Wa6gIcljpEUpLMtFqAhJCT+Y
	 RMTM1OxO+1i6gxJ3DNH1szE/uQXK/wbIqbS/tK1yrk6+VYMTN5DmHDIyfGxoKnojl0TU/
	 xjqDhMCWTtXK+k1YR2krgZcD0psuoTWNk6Wq3Sn+FXdyO7KIIEiOYGgnPnMlJCVFKBWgj
	 1OI89i+KckX41216wObwxVTUeOawO6U4VwM0O2EH6zj91sYliq7mltt9BgWIjfnwsyA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ph4ntom-rev.uz;
	spf=pass smtp.mailfrom=ph4ntom-rev.uz;
	dkim=pass header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=svDicBJE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.54
Received: from sender5-of-o54.zoho.com (sender5-of-o54.zoho.com [165.173.182.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920E2606AE05;
	Wed,  4 Nov 2026 20:31:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 920E2606AE05
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=svDicBJE
ARC-Seal: i=1; a=rsa-sha256; t=1793824260; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=WTQgkwmxQCnVladPaclBCcO6R7KEAzRweReUOxNlbvWGqKjSfuJSfCTmzrZq3XQ4AfAdzRSiR29yFYK91AxhmiVLEX9lVf7mvmAMFzE640uctSo6EYkdM1OJ5n/3K/TbLg3fe0CGKmI7Xq4Ky3OaiSoskOE4ww87txBUXdrM2L0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1793824260; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=U4L4/KbrFieS+0UXgWqlk7B9bXIXbAaNfkWea0yLlQ8=; 
	b=eu7xexcKlNTbDlFmQCfxi1kmIKLByX6VoOaRPhBiB38PbFPANuCspBDdcdpoHWsqxi3Z0KzasivOS7P0h1dmc6nLw0kr31xUKyqFHLRLNm8eBVQWiiVTD9H6XG20D1Cqp6puIJvIqlCdSxajuQ2tWa5oaoeoaBgN2Maa5tZbKIc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ph4ntom-rev.uz;
	spf=pass  smtp.mailfrom=owner@ph4ntom-rev.uz;
	dmarc=pass header.from=<owner@ph4ntom-rev.uz>
DKIM-Signature: a=rsa-sha256; b=svDicBJEiPu6BCxyyNEhad72cl3N/Ue3fqcTNo7paY6aXWxm6M1fyNFmfmp2Qrc6dd4DzCZoNRYFioUbyRnlXBZtDMbPkkO/bTCxdvmLflxZIwzk3mdukJQx1Zq2hq4cKSuHBN0EpmeGAPKf0ndSK2PfQMl5XeLBOzz6dc3WmlrmnyiGQ3B9zL8OOFovXD2Hy70hZuQgyR5NYWU+Ty9F+2ELU1X90SJhKcmZCOJlY3zEZZ5o0evugitmmGSO+BmOPcYggssq5VhVmT1UvD+xFOoQkNoXIZvW5ynlW2/51+4dHoybw9K5pKQE7jxbUBIKcnVSbYb3D6TzFigNtZY/qg==; c=relaxed/relaxed; s=zoho; d=ph4ntom-rev.uz; v=1; bh=U4L4/KbrFieS+0UXgWqlk7B9bXIXbAaNfkWea0yLlQ8=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1793824257718589.5105838531466;
	Wed, 4 Nov 2026 12:30:57 -0800 (PST)
From: Enver <owner@ph4ntom-rev.uz>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	kvalo@kernel.org,
	linux-kernel@vger.kernel.org,
	Enver <owner@ph4ntom-rev.uz>
Subject: [PATCH v3 0/3] wifi: rtw89: monitor RX filtering, raw injection and channel restore
Date: Thu,  5 Nov 2026 01:30:48 +0500
Message-ID: <20261104203051.564-1-owner@ph4ntom-rev.uz>
X-Mailer: git-send-email 2.56.0.windows.4
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

This series supersedes the v2 monitor-mode series:
https://lore.kernel.org/linux-wireless/179371849554.20972.16232816164394690660@ph4ntom-rev.uz/
https://lore.kernel.org/linux-wireless/179371849554.20972.4737532522625772373@ph4ntom-rev.uz/

Changes in v3:
- remove redundant RX filter, sleep-register and scheduler operations;
- add rollback and error reporting for monitor firmware join state;
- restore channel and RF calibration after monitor interface recreation;
- disconnect the firmware role if channel restoration fails, while
  preserving the original error and protecting VIF teardown with RCU.

The post-stress RX failure was traced to missing channel restoration
after stop/start. When monitor_chanreq is unchanged, mac80211 does not
issue a channel-change callback, so rtw89_set_channel() is not called.
Forcing a different channel and then restoring it confirms that RX
recovers without reloading the driver.

Patch 3/3 identifies the commit that introduced monitor-specific RF
calibration and completes its restart lifecycle.

Validation on RTL8852AE, Linux 7.1.5+kali-amd64:
- 25 monitor recreate cycles with raw TX: 16,670 post-stress frames,
  225 beacons and 30/30 injection responses from one AP;
- 25 recreate cycles without raw TX: 20,517 post-stress frames;
- no new kernel alerts in the normal stress runs;
- managed scanning and association work;
- forced -EINVAL rollback testing verifies join_info(true) before
  link cleanup and returns the original error to mac80211;
- sequential application of all three patches succeeds;
- full Linux 7.3.0 build, W=1, sparse and checkpatch pass.

Both APs responded at baseline. In the final post-stress injection run,
one AP answered 30/30 probes; the other AP is not listed as answering
in the parsed report, so this is not claimed as a 30/30 result from
both APs.

Earlier review requested the default R_AX_CTRL_FLTR value and a real
raw-socket reproducer. The measured default value is 0x55555555.
The actual reproducer is scripts/verify_hardware.py, including raw
AF_PACKET injection, monitor recreation and PCAP/dmesg collection.
The NULL-VIF path is reached through ieee80211_xmit(sdata, NULL, skb);
it is not asserted that every injection supplies a NULL VIF.
RCU publication, reader locking, clearing and synchronize_rcu() are
used to protect monitor VIF lifetime during TX and teardown.

Only RTL8852AE has been tested. Other rtw89 chips, DBCC/MAC 1
configurations, long-term operation and historical runtime of the
Fixes commit have not been verified. No claim is made for successful
over-air injection of every control-frame subtype.

Development and validation assistance: Kimi Code (Moonshot AI).
The assistant helped analyze the failure, inspect firmware, draft the
patch and run the validation. The submitter reviewed the final changes
and takes responsibility for the submission.
---
