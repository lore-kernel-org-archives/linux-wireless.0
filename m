Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792776151;
	b=LPT6rtp/WyDy+57egCNY0CZPrpJ7grbbJoXfn5GmeT8DapBIrhWAE8xDNH7IKOFIAU6b
	 BjpfZ/gexqMuHs76xciKCqAQDVQZPvGrIbjCl9pEvrypoI9bWKLPJYbEoLsOznTXFbrIw
	 d++VE936shohTwMADB2s2t6J9EH+msp6kXVpJMkif/kt43c4ZbwdWQHek6LMLG+vq4heT
	 oHk9ImE/Uc+NcTUijc4yro2EvqUawUNo8yviIg/4XOSNThBkUebnTVVafjvvN6o4uonfi
	 y15LLcq4NdzyhJJpD/k/bWvs6efTEgd0ASnGuCn743C8djejOLR50or86MoPvNB7tGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792776151;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=OqIzqzKA47bvFdvWSzkbJtTIaw3nSYA/gtwEAEp+wpE=;
	b=NfHEJXmXhlkCDeHx7KcpWudMdoPpvM/jjSSUReQuxRc0n6yO3I/VtrzE3RfIddX8FTwT
	 zcD1oDrkmR49Sk+G8UKxjQwniktD+uVUn29x2PCwT2TDqFbtKMrd4SeYoCrqOnvOdG+D3
	 pi3VdZAPVWl5XeSATrlWMHY1WJGIq+Ty7swFb6dkWTwD/RGkxeUXTx7wpJ9Ffu7yyAGOM
	 TXsxfFGCrT1Z/kZM+5s+H9YsR8mSbZPpkU9r+1YHZQxEuc+TYXpDiPyH4/sAUhdeDYnat
	 dLBGPUb8gfNVYPVqhRYZb6ltnQ8z5NLFS8TyuBT5KESD7nepCqSfB6tY9gCGZR4TsIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y2sHzF+a;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C12A606A31A;
	Fri, 23 Oct 2026 17:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y2sHzF+a
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792776150;
	b=NtuDqXc7z1APAbebS4r3ew5gmhkvZqdLLaEVauQnuOizF1VzM9XRutkPMKEkwV2Hz9CT
	 7U65MTL7rHnjcctPWGasSiN5oMvn9x9koOMN2nRn+APTr5ds9FC4VSqZXQrb72Lqqd0Bx
	 0PupVIHmG3Ec/ATXLpP+1mNge3ewz6nBxxHm2fJnoCGGC9Q+1WyqWmgETjWjP37GFn+pP
	 nu/ZCL0CdvpVVZcgL/dR1Gz9t+Bk7Is1jLa2WFRRlJOonL5kbmNhu/DDyh4TCVDDnWp2k
	 Zlgy17h7SoGh0Ok8kQhc8af4YaVAyMCCUOkwQ7GtaK5qJrz+nCDOM/WAgI8a6PXyxZQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792776150;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=OqIzqzKA47bvFdvWSzkbJtTIaw3nSYA/gtwEAEp+wpE=;
	b=CCFLHawaVfi3PdcA3BFynlDOY1ulumCjWTXizYtPp9gO4mV+zkzxJBNWTUZk4aizU5Nw
	 60mdF4d2AMTPof+Wmsh7euyx8bwBhpJjxA6aY6OTOResnzMf4dAtbpf8HyHV+ytUj30Ya
	 Bt5xBKTxoHeEW7XdR3d2Ieh4K8VpDflWwPhQpaO1vFSqkufFLcRDnnGt3kpnms7Op/nkv
	 ntrm0puUyb7NryliWQZJ6Z0vMGQbE9TIxjf3UOgCctJdM5RggniNQ/L+q0xOaKyGTssmJ
	 c5ya1uv1crBbR6x4Je2QYGanAHj3E2eWk3kqfdd77wf8eNqlBJn6lugArpjNl3AFdEQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 73CFA1F01825;
	Fri, 23 Oct 2026 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792776150;
	bh=OqIzqzKA47bvFdvWSzkbJtTIaw3nSYA/gtwEAEp+wpE=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=Y2sHzF+aquMXEf4Rv7oIEnmuebyIb/wbWTG9IZwI7bcDFQ/SPRPFmCM4F7s0qqGpP
	 D9wBpRiSm2micgzIq4fXmgP34m/zsH6lJ63C9ZwBaNFgJHtC6WPE7xCE+vC+K1xPH7
	 lWzMPGm4gWnMhQUsE599A6pYILOLHx/FSY+RnnotPbV87+feTnnHGiW0jVBPl1DKXC
	 ppcbPYT6mtnI+vb3p7JibF/BsIM2e7bKc8ckE5BQ7MxsLhiBkDuBCmPEAIj0BcTtTL
	 lK296BwfAjXzSBKByE7tU6ilrKfB5ZmokuFcuJ2+IQQkBYsdZAit6FTLhtfwy7W5wH
	 RSDyhAmuiKNXA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id F13E2445A0;
	Fri, 23 Oct 2026 17:22:29 +0000 (UTC)
From: =?utf-8?q?Lo=C3=AFc_Kassel_via_B4_Relay?= <devnull+loic.kassel.gmail.com@kernel.org>
Date: Fri, 23 Oct 2026 19:21:54 +0200
Subject: [PATCH wireless] wifi: mac80211_hwsim: use CLOCK_BOOTTIME for the
 beacon timer
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261023-hwsim-beacon-clock-v1-1-9b3f3ffc099b@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQrCMBBG4auUWTuQRJC2VxEXcfrXDraJZKARS
 u9ucPkt3jvIUBRGY3dQwa6mOTX4S0eyxPQC69RMwYWbd+HKSzXd+IkoObGsWd6M2M/wk5Nh6Km
 Fn4JZv//pnaoWrDCjx3n+AGkPCAZuAAAA
X-Change-ID: 20261023-hwsim-beacon-clock-ea8fe1d0c998
To: Johannes Berg <johannes@sipsolutions.net>, 
 Benjamin Berg <benjamin.berg@intel.com>, 
 Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Lo=C3=AFc_Kassel?= <loic.kassel@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792776149; l=2489;
 i=loic.kassel@gmail.com; s=20261023; h=from:subject:message-id;
 bh=pcL4DXeSmeZCNbu0odCOcRBBfSJ6zAv3ONG4ux6DNnE=;
 b=U3rRFkEZroe2nHeMsYy0UB62+omfo4r4pYx8C4+PAvwcAnH4Oakmla/sLkFzEO8wb33TzCkbo
 /Lu/O+6TjsUBW9ZoFFUPEZBRF3gEUDpgJnfExmkIgfK7JMrXM31YAps
X-Developer-Key: i=loic.kassel@gmail.com; a=ed25519;
 pk=8MjN6l7+bGFfW7/nYXQfpGkxGFb6lH8T7uhKv5XLruA=
X-Endpoint-Received: by B4 Relay for loic.kassel@gmail.com/20261023 with
 auth_id=1290
X-Original-From: =?utf-8?q?Lo=C3=AFc_Kassel?= <loic.kassel@gmail.com>
Reply-To: loic.kassel@gmail.com
Content-Transfer-Encoding: 8bit

From: Loïc Kassel <loic.kassel@gmail.com>

The simulated TSF is based on boottime, and the beacon timer is re-armed
with an absolute expiry derived from the TSF through
mac80211_hwsim_tsf_to_boottime(). The timer itself is however still set
up with CLOCK_MONOTONIC.

Boottime keeps running while the system is suspended, monotonic does
not. After the host has been suspended once, every beacon is therefore
scheduled too late by the total time spent in suspend, and APs
practically stop sending beacons.

Set the beacon timer up with CLOCK_BOOTTIME so that it is consistent
with the TSF.

The bug was analysed, and this change and commit message drafted, with
the help of an AI assistant (Claude, Opus 5.5). I reviewed the change
and tested it on v7.2.11 (Fedora 44), applying the same one-line change
to that kernel's mac80211_hwsim and loading it as an out-of-tree module.
With hostapd started after a suspend (boottime 61 s ahead of monotonic),
an associated station received about 10 beacons per second with no
beacon loss, and scans found all APs. With the unmodified module, in the
same situation, beacons practically stopped and APs without associated
stations were not found by scans.

Fixes: 933f5bec98a1 ("wifi: mac80211_hwsim: register beacon timer by calculating TBTT")
Closes: https://lore.kernel.org/linux-wireless/CAAzpgGdksHZjx4jc20zqnAG_PQ2e1ggANQjt2eiycUiWc+vPHg@mail.gmail.com/
Signed-off-by: Loïc Kassel <loic.kassel@gmail.com>
---
Benjamin confirmed the analysis in the report thread and suggested that
I send the fix myself. This is my first kernel patch.
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index b9446577ff..203bf9a4b9 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -6136,7 +6136,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 
 	for (i = 0; i < ARRAY_SIZE(data->link_data); i++) {
 		hrtimer_setup(&data->link_data[i].beacon_timer, mac80211_hwsim_beacon,
-			      CLOCK_MONOTONIC, HRTIMER_MODE_ABS_SOFT);
+			      CLOCK_BOOTTIME, HRTIMER_MODE_ABS_SOFT);
 		data->link_data[i].link_id = i;
 	}
 

---
base-commit: 9d8ec0b5b5295bd23d979d1b2b905de25c36fff2
change-id: 20261023-hwsim-beacon-clock-ea8fe1d0c998

Best regards,
-- 
Loïc Kassel <loic.kassel@gmail.com>


